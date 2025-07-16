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
    -- Create a Lua function for SmartQuit
    local function smart_quit()
      if vim.bo.filetype == 'NvimTree' then
        -- Do nothing in NvimTree
        return
      else
        -- Use Bwipeout for other buffers
        vim.cmd('Bwipeout')
      end
    end
    
    -- Store the function globally so it can be called from command abbreviations
    _G.SmartQuit = smart_quit
    
    -- Create command abbreviations using Lua
    vim.cmd('cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == "q" ? "lua SmartQuit()" : "q"')
    vim.cmd('cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "write <bar> lua SmartQuit()" : "wq"')
  end,
  desc = 'Setup smart quit commands after plugins are loaded'
})
