local icons = require('config.icons')

local on_attach = function(client, buffer_number)
	local options = {
		noremap = true,
		silent = true,
	}
	
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gd', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', options)
	-- vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'K', '<Nop>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', options)

	vim.keymap.set('n', '<leader>dF', function()
		vim.cmd('tab split')
		vim.lsp.buf.definition()
	end, { buffer = buffer_number, silent = true, desc = 'Go to definition in new tab' })
end

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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {
	rust_analyzer = {
		cmd = { 'rust-analyzer' },
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
	on_attach = on_attach,
	capabilities = capabilities,
})

for name, config in pairs(servers) do
	vim.lsp.config(name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))
