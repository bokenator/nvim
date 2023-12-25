-- Auto command for Linting on Save
vim.api.nvim_create_augroup('LintOnSave', {clear = true})
vim.api.nvim_create_autocmd('BufWritePost', {
	group = 'LintOnSave',
	pattern = '*.rs',
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
})
