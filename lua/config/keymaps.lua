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

-- Better window navigation
vim.keymap.set('n', '<m-h>', '<C-w>h', options)
vim.keymap.set('n', '<m-j>', '<C-w>j', options)
vim.keymap.set('n', '<m-k>', '<C-w>k', options)
vim.keymap.set('n', '<m-l>', '<C-w>l', options)
vim.keymap.set('n', '<m-s>', '<c-6>', options)
vim.keymap.set('n', '<m-n>', ':bn<CR>', options)
vim.keymap.set('n', '<m-p>', ':bp<CR>', options)
