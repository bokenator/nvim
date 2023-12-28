-- Auto command for Linting on Save
vim.api.nvim_create_augroup('LintOnSave', {clear = true})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	group = 'LintOnSave',
	pattern = '*.rs',
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
})

-- Bind q to closing windows
vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = {
		'Jaq',
		'qf',
		'git',
		'help',
		'man',
		'lspinfo',
		'spectre_panel',
		'lir',
		'DressingSelect',
		'tsplayground',
		'',
	},
	callback = function()
		vim.cmd [[
			nnoremap <silent> <buffer> q :close<CR>
			set nobuflisted
		]]
	end,
})

-- Ensure the file being edited is the latest version
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
	pattern = { '*' },
	callback = function()
		vim.cmd 'checktime'
	end,
})

-- Disable command mode
vim.api.nvim_create_autocmd({ 'CmdWinEnter' }, {
	callback = function()
		vim.cmd 'quit'
	end,
})

-- Disable netrw
vim.api.nvim_create_autocmd({'FileType'}, {
	pattern = 'netrw',
	callback = function()
		vim.cmd 'quit'
	end,
})

-- Resize the windows to same size
vim.api.nvim_create_autocmd({ 'VimResized' }, {
	callback = function()
		vim.cmd 'tabdo wincmd ='
	end,
})

-- Show visual confirmation of yanked content
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
	callback = function()
		vim.highlight.on_yank { higroup = 'Visual', timeout = 40 }
	end,
})
