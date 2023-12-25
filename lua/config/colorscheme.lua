vim.cmd.colorscheme('vscode')

-- Set the float UI to have transparent background color
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
