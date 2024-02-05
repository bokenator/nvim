local multipleCursors = require('multiple-cursors')

multipleCursors.setup({
	match_visible_only = false,
	pre_hook = function()
		vim.g.minipairs_disable = true
	end,
	post_hook = function()
		vim.g.minipairs_disable = false
	end,
})

vim.keymap.set({'n', 'i'}, '<C-Down>', '<cmd>MultipleCursorsAddDown<CR>', options)
vim.keymap.set('n', '<C-j>', '<cmd>MultipleCursorsAddDown<CR>', options)
vim.keymap.set({'n', 'i'}, '<C-Up>', '<cmd>MultipleCursorsAddUp<CR>', options)
vim.keymap.set('n', '<C-k>', '<cmd>MultipleCursorsAddUp<CR>', options)
vim.keymap.set({'n', 'i'}, '<C-LeftMouse>', '<cmd>MultipleCursorsMouseAddDelete<CR>', options)
vim.keymap.set({'n', 'x'}, '<Leader>a', '<cmd>MultipleCursorsAddBySearchV<CR>', options)
vim.keymap.set({'n', 'x'}, '<Leader>A', '<cmd>MultipleCursorsAddBySearchV<CR>', options)
vim.keymap.set({'n', 'x'}, '<C-a>', '<cmd>MultipleCursorsAddBySearchOne<CR>', options)

