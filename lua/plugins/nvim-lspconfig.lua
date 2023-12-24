local lspconfig = require('lspconfig')
local icons = require('../icons')

local on_attach = function(client, buffer_number)
	local options = {
		noremap = true,
		silent = true,
	}
	
	vim.api.nvim_buf_set_keymap(buffer_number, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", options)
	vim.api.nvim_buf_set_keymap(buffer_number, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", options)
	vim.api.nvim_buf_set_keymap(buffer_number, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", options)
	vim.api.nvim_buf_set_keymap(buffer_number, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", options)
	vim.api.nvim_buf_set_keymap(buffer_number, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", options)
	vim.api.nvim_buf_set_keymap(buffer_number, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", options)
end

vim.diagnostic.config({
	signs = {
		active = true,
		values = {
			{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
			{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
			{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
			{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
		},
	},
	virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
    },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

lspconfig['rust_analyzer'].setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
				preferNoStd = true,
				granularity = {
					enforce = true,
				},
			},
			inlayHints = {
			},
		},
	}
})

