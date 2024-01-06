local colors = require('vscode.colors').get_colors()

require('bufferline').setup({
	highlights = {
		-- When the buffer is selected, and cursor is in the buffer window
		modified_selected = {
			fg = colors.vscFront,
		},
		-- When the buffer is selected, but cursor is in another window
		buffer_visible = {
			fg = colors.vscFront,
		},
		close_button_visible = {
			fg = colors.vscFront,
		},
		modified_visible = {
			fg = colors.vscFront,
		},
		-- When the buffer is not selected
		background = {
			fg = colors.vscLeftLight,
		},
		close_button = {
			fg = colors.vscLeftLight,
		},
		modified = {
			fg = colors.vscLeftLight,
		},
	},
	options = {
		offsets = {
			{
				filetype = 'NvimTree',
				text = 'File Explorer',
				text_align = 'left',
				separator = false,
			},
		},
		diagnostics = 'nvim_lsp',
		diagnostics_update_in_insert = true,
		always_show_bufferline = true,
	},
})

local options = {
	noremap = true,
	silent = true,
}

vim.keymap.set('n', '<m-s>', '<c-6>', options)
vim.keymap.set('n', '<m-n>', ':BufferLineCycleNext<CR>', options)
vim.keymap.set('n', '<m-p>', ':BufferLineCyclePrev<CR>', options)
vim.keymap.set('n', '<m-N>', ':BufferLineMoveNext<CR>', options)
vim.keymap.set('n', '<m-P>', ':BufferLineMovePrev<CR>', options)
