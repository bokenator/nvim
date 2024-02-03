local preview = require('goto-preview')

preview.setup({
	width = 120,
	height = 15,
	border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
	default_mappings = false,
	debug = false,
	opacity = nil,
	resizing_mappings = false,
	post_open_hook = nil,
	post_close_hook = nil,
	references = {},
	focus_on_open = true,
	dismiss_on_move = false,
	force_close = true,
	bufhidden = 'wipe',
	stack_floating_preview_windows = true,
	preview_window_title = { enable = true, position = 'center' },
})

local options = {
	noremap = true,
	silent = true,
}

vim.keymap.set('n', 'gD', '<cmd>lua require(\'goto-preview\').goto_preview_declaration()<CR>', options)
vim.keymap.set('n', 'gt', '<cmd>lua require(\'goto-preview\').goto_preview_type_definition()<CR>', options)
vim.keymap.set('n', 'gd', '<cmd>lua require(\'goto-preview\').goto_preview_definition()<CR>', options)
vim.keymap.set('n', 'gI', '<cmd>lua require(\'goto-preview\').goto_preview_implementation()<CR>', options)
vim.keymap.set('n', 'gQ', '<cmd>lua require(\'goto-preview\').close_all_win()<CR>', options)
vim.keymap.set('n', 'gr', '<cmd>lua require(\'goto-preview\').goto_preview_references()<CR>', options)
