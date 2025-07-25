vim.opt.backup = false			-- Create a backup
vim.opt.hlsearch = true			-- Highlight all matches on previous search pattern
vim.opt.mouse = 'a'				-- Allow the mouse to be used in neovim
vim.opt.pumheight = 10			-- Popup menu height
vim.opt.pumblend = 10
vim.showtabline = 1				-- Always show tabs
vim.opt.smartcase = true		-- Smart case
vim.opt.smartindent = true		-- Make indenting starter again
vim.opt.swapfile = false		-- Creates a swapfile
vim.opt.termguicolors = true	-- Set term gui colors
vim.opt.undofile = true			-- Enable persistent undo
vim.opt.updatetime = 100		-- Faster completion (4000ms default)
vim.opt.shiftwidth = 4			-- The number of spaces inserted for each indentation
vim.opt.tabstop = 4				-- Insert 2 spaces for a tab
vim.opt.cursorline = true		-- Highlight the current line
vim.opt.number = true			-- Set numbered lines
vim.opt.relativenumber = true	-- Set relative numbered lines
vim.opt.signcolumn = 'yes'		-- Always show the sign column, otherwise it would shift whenever diagnostic is shown
vim.opt.title = false
vim.opt.fillchars = {			-- Hide the vertical bar separating tree and editor
	vert = ' ',
	eob = ' ',
}
vim.opt.wrap = false
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 5
vim.g.rust_recommended_style = true

-- Allow project-specific configuration files
vim.o.exrc = true				-- Read .nvimrc/.exrc in current directory
vim.o.secure = true				-- Restrict commands in local config files for security

