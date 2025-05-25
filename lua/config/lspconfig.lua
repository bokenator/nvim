local lspconfig = require('lspconfig')
local icons = require('config.icons')

local on_attach = function(client, buffer_number)
	local options = {
		noremap = true,
		silent = true,
	}
	
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
	--vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'K', '<Nop>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
	vim.api.nvim_buf_set_keymap(buffer_number, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', options)
end

vim.diagnostic.config({
	signs = {
		active = true,
		values = {
			{ name = 'DiagnosticSignError', text = icons.diagnostics.Error },
			{ name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
			{ name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
			{ name = 'DiagnosticSignInfo', text = icons.diagnostics.Information },
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

-- Enable icons for diagnostic signs
for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), 'signs', 'values') or {}) do
	vim.fn.sign_define(sign.name, {
		texthl = sign.name,
		text = sign.text,
		numhl = sign.name,
	})
end

-- Add rounded border to hover tooltips
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
require('lspconfig.ui.windows').default_options.border = 'rounded'

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Rust
lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	-- Specify the path to rust-analyzer binary
	cmd = { "rust-analyzer" },
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
			inlayHints = {
			},
		},
	},
})

-- JSON
lspconfig.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
})

-- Typescript/javascript
lspconfig.ts_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Python
lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = 'workspace',
				useLibraryCodeForTypes = true,
			},
		},
	},
})

