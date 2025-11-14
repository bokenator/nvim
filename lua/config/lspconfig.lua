local icons = require('config.icons')

local is_list = vim.islist or vim.tbl_islist

local capabilities ---@type table|nil
local servers ---@type table<string, table>

local warmup_methods = {
	'textDocument/definition',
	'textDocument/declaration',
}

local function normalize_path(path)
	return vim.loop.fs_realpath(path) or path
end

local function get_offset_encoding(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		if client.offset_encoding then
			return client.offset_encoding
		end
	end
	return 'utf-16'
end

local function warmup_client(client, bufnr)
	if vim.b[bufnr]._config_lsp_warmup_done then
		return
	end
	vim.b[bufnr]._config_lsp_warmup_done = true

	vim.defer_fn(function()
		if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
			return
		end

		local encoding = client.offset_encoding or get_offset_encoding(bufnr)
		local win = vim.fn.bufwinid(bufnr)
		if win == -1 then
			win = 0
		end

		for _, method in ipairs(warmup_methods) do
			if client.supports_method(method) then
				local params = vim.lsp.util.make_position_params(win, encoding)
				client.request(method, params, function() end, bufnr)
			end
		end
	end, 100)
end

local function start_server_for_root(name, root_dir)
	local resolved = vim.lsp.config[name]
	if not resolved then
		return
	end

	local config = vim.deepcopy(resolved)
	config.root_dir = root_dir
	config.on_attach = nil
	config.capabilities = vim.tbl_deep_extend('force', config.capabilities or {}, capabilities or {})
	config.workspace_folders = config.workspace_folders
		or { { name = vim.fs.basename(root_dir), uri = vim.uri_from_fname(root_dir) } }

	-- Avoid starting duplicate clients
	for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
		local client_root = client.config.root_dir and normalize_path(client.config.root_dir)
		if client_root == normalize_path(root_dir) then
			return
		end
	end

	vim.lsp.start(config, {
		attach = false,
		bufnr = 0,
		silent = true,
	})
end

local function prewarm_projects(cwd)
	cwd = cwd and normalize_path(cwd) or normalize_path(vim.fn.getcwd())
	for name, server in pairs(servers) do
		local markers = server.root_markers
		if markers then
			local root = vim.fs.root(cwd, markers)
			if root then
				start_server_for_root(name, root)
			end
		end
	end
end

local function jump_to_location(method, title)
	return function()
		local bufnr = vim.api.nvim_get_current_buf()
		local encoding = get_offset_encoding(bufnr)
		local params = vim.lsp.util.make_position_params(0, encoding)
		vim.lsp.buf_request(0, method, params, function(err, result, ctx)
			if err then
				vim.notify(string.format('%s request failed: %s', method, err.message or err), vim.log.levels.ERROR)
				return
			end

			if not result or vim.tbl_isempty(result) then
				local label = title or method
				vim.notify(string.format('No results from %s', label), vim.log.levels.INFO)
				return
			end

			local client = ctx and vim.lsp.get_client_by_id(ctx.client_id)
			if not client then
				return
			end

			local locations = is_list(result) and result or { result }
			local offset_encoding = client.offset_encoding or encoding

			local ok = vim.lsp.util.show_document(locations[1], offset_encoding, {
				reuse_win = true,
				focus = true,
			})

			if not ok then
				return
			end

			if #locations > 1 then
				local ok, items = pcall(vim.lsp.util.locations_to_items, locations, offset_encoding)
				if ok and items and #items > 0 then
					vim.fn.setqflist({}, ' ', {
						title = title or method,
						items = items,
					})
					vim.notify(string.format('Multiple %s found (%d). Check the quickfix list.', title or method, #items), vim.log.levels.INFO)
				end
			end
		end)
	end
end

local on_attach = function(client, buffer_number)
	if vim.b[buffer_number]._config_lsp_attached then
		return
	end
	vim.b[buffer_number]._config_lsp_attached = true

	local options = {
		noremap = true,
		silent = true,
	}
	
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', options)
	-- vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'K', '<Nop>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', options)

	local goto_definition = jump_to_location('textDocument/definition', 'Definitions')
	local goto_declaration = jump_to_location('textDocument/declaration', 'Declarations')

	vim.keymap.set('n', '<leader>dF', goto_definition, {
		buffer = buffer_number,
		silent = true,
		desc = 'Go to definition',
	})

	vim.keymap.set('n', 'gd', goto_definition, {
		buffer = buffer_number,
		silent = true,
		desc = 'Go to definition',
	})

	vim.keymap.set('n', 'gD', goto_declaration, {
		buffer = buffer_number,
		silent = true,
		desc = 'Go to declaration',
	})

	warmup_client(client, buffer_number)
end

local attach_group = vim.api.nvim_create_augroup('config.lsp.attach', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
	group = attach_group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			on_attach(client, args.buf)
		end
	end,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = icons.diagnostics.Error,
			[severity.WARN] = icons.diagnostics.Warning,
			[severity.HINT] = icons.diagnostics.Hint,
			[severity.INFO] = icons.diagnostics.Information,
		},
	},
	virtual_text = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = 'minimal',
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

-- Add rounded border to hover tooltips
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
require('lspconfig.ui.windows').default_options.border = 'rounded'

capabilities = require('cmp_nvim_lsp').default_capabilities()

servers = {
	rust_analyzer = {
		cmd = { 'rust-analyzer' },
		root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
		settings = {
			['rust-analyzer'] = {
				checkOnSave = true,
				diagnostics = {
					enable = true,
					experimental = {
						enable = true,
					},
				},
				imports = {
					preferNoStd = false,
					granularity = {
						enforce = true,
					},
				},
				inlayHints = {},
			},
		},
	},
	jsonls = {
		settings = {
			json = {
				format = {
					enable = true,
				},
			},
			validate = {
				enable = true,
			},
		},
	},
	ts_ls = {},
	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = 'workspace',
					useLibraryCodeForTypes = true,
				},
			},
		},
	},
	taplo = {
		settings = {
			taplo = {
				formatter = {
					alignEntries = true,
					alignComments = true,
					arrayTrailingComma = true,
					arrayAutoExpand = true,
					arrayAutoCollapse = true,
					compactArrays = true,
					compactInlineTables = false,
					compactEntries = false,
					columnWidth = 80,
					indentTables = false,
					indentEntries = false,
					indentString = '  ',
					trailingNewline = true,
					reorderKeys = true,
					allowedBlankLines = 2,
				},
			},
		},
	},
}

if not (vim.lsp and vim.lsp.config) then
	local ok, lspconfig = pcall(require, 'lspconfig')
	if not ok then
		vim.notify('nvim-lspconfig is not available; update Neovim to 0.11+ or install nvim-lspconfig.', vim.log.levels.ERROR)
		return
	end

	for name, config in pairs(servers) do
		local server_config = vim.tbl_deep_extend('force', {}, config, {
			on_attach = on_attach,
			capabilities = capabilities,
		})

		if lspconfig[name] and lspconfig[name].setup then
			lspconfig[name].setup(server_config)
		else
			vim.notify(string.format('LSP server "%s" is not available in nvim-lspconfig.', name), vim.log.levels.WARN)
		end
	end

	return
end

vim.lsp.config('*', {
	capabilities = capabilities,
})

for name, config in pairs(servers) do
	vim.lsp.config(name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))

vim.schedule(function()
	prewarm_projects()
end)

local project_group = vim.api.nvim_create_augroup('config.lsp.project', { clear = true })

vim.api.nvim_create_autocmd('DirChanged', {
	group = project_group,
	callback = function(args)
		prewarm_projects(args.file)
	end,
})

