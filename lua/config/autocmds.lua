-- Auto command for Linting on Save
vim.api.nvim_create_augroup('LintOnSave', {clear = true})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	group = 'LintOnSave',
	pattern = {
		'*.rs',
		'*.ts',
		'*.js',
		'*.json',
	},
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Bind q to closing windows
vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = {
		'netrw',
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

-- Auto-reload files when changed externally
vim.o.autoread = true

-- Check for file changes every 100ms
vim.fn.timer_start(100, function()
	if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == '' then
		vim.cmd 'silent! checktime'
	end
end, { ['repeat'] = -1 })

-- Notify when file is changed externally and tell LSP to re-index
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
	pattern = { '*' },
	callback = function()
		vim.notify('File changed on disk. Buffer reloaded!', vim.log.levels.INFO)
		
		-- Notify LSP clients about the file change
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
		
		for _, client in ipairs(clients) do
			-- Send didSave notification to trigger re-indexing
			client.notify('textDocument/didSave', {
				textDocument = {
					uri = vim.uri_from_bufnr(bufnr),
				}
			})
		end
	end,
})

-- Disable command mode
vim.api.nvim_create_autocmd({ 'CmdWinEnter' }, {
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
