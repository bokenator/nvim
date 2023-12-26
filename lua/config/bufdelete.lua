local options = {
	noremap = true,
	silent = true,
}

vim.keymap.set('n', 'Q', ':lua require("bufdelete").bufdelete(0, false)<cr>', options)
