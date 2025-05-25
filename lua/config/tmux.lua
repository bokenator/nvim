-- create an augroup so we don't double-register
local group = vim.api.nvim_create_augroup('YankToTmux', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	group = group,
	callback = function()
		-- Check if we're in a tmux session
		if not vim.env.TMUX then
			return
		end
		
		-- Get the contents of the unnamed register as a list of lines
		local lines = vim.fn.getreg('"', 1, true)
		
		-- Only proceed if there's actually text to copy
		if lines and #lines > 0 then
			-- Convert lines array to a single string with newlines
			local text = table.concat(lines, '\n')
			-- Push into tmux's paste buffer using system call
			vim.fn.system('tmux load-buffer -', text)
		end
	end,
})
