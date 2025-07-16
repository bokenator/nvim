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

-- Clipboard operations
vim.keymap.set('v', '<m-c>', '"+y', options)
vim.keymap.set('n', '<leader>c', ':%y+<CR>', options)

-- Map :q to use Bwipeout, but do nothing in NvimTree
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd([[
      function! SmartQuit()
        if &filetype == 'NvimTree'
          " Do nothing in NvimTree
          return
        else
          " Use Bwipeout for other buffers
          execute 'Bwipeout'
        endif
      endfunction
      
      cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == "q" ? "call SmartQuit()" : "q"
      cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "write <bar> call SmartQuit()" : "wq"
    ]])
  end,
  desc = 'Setup smart quit commands after plugins are loaded'
})
