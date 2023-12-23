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

-- nvim-tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', options)
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', options)
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', options)

