local options = {
	noremap = true,
	silent = true,
}

-- Set the leader key to <Space>
vim.keymap.set('n', '<Space>', '', options)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Indentation
vim.keymap.set('v', '<', '<gv', options)
vim.keymap.set('v', '>', '>gv', options)

