local multipleCursors = require('multiple-cursors')

multipleCursors.setup({
	pre_hook = function()
		require('nvim-autopairs').disable()
	end,
	post_hook = function()
		require('nvim-autopairs').enable()
	end,
})

vim.keymap.set({'n', 'i'}, '<C-Down>', '<cmd>MultipleCursorsAddDown<CR>', options)
vim.keymap.set('n', '<C-j>', '<cmd>MultipleCursorsAddDown<CR>', options)
vim.keymap.set({'n', 'i'}, '<C-Up>', '<cmd>MultipleCursorsAddUp<CR>', options)
vim.keymap.set('n', '<C-k>', '<cmd>MultipleCursorsAddUp<CR>', options)
vim.keymap.set({'n', 'i'}, '<C-LeftMouse>', '<cmd>MultipleCursorsAddDelete<CR>', options)
vim.keymap.set({'n', 'x'}, '<Leader>a', '<cmd>MultipleCursorsAddBySearch<CR>', options)
vim.keymap.set({'n', 'x'}, '<Leader>A', '<cmd>MultipleCursorsAddBySearch<CR>', options)

