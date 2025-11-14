local options = {
	noremap = true,
	silent = true,
}

-- Set the leader key to <Space>
vim.keymap.set('n', '<Space>', '', options)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable mouse support
vim.o.mouse = 'a'

-- Configure smooth horizontal scrolling
vim.o.sidescroll = 1
vim.o.sidescrolloff = 5

-- Horizontal panning with arrow keys
vim.keymap.set('n', '<Left>',  '5zh', options)
vim.keymap.set('n', '<Right>', '5zl', options)

-- Shift + ScrollWheel for horizontal scrolling
vim.keymap.set({'n', 'v'}, '<C-ScrollWheelUp>',   '5zh', options)
vim.keymap.set({'n', 'v'}, '<C-ScrollWheelDown>', '5zl', options)
vim.keymap.set('i', '<C-ScrollWheelUp>',   '<C-o>5zh', options)
vim.keymap.set('i', '<C-ScrollWheelDown>', '<C-o>5zl', options)

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
    local function try_bwipeout(force)
      local cmd = 'Bwipeout' .. (force and '!' or '')
      local ok = pcall(vim.cmd, cmd)
      if not ok then
        vim.cmd(force and 'bdelete!' or 'bdelete')
      end
    end

    -- Create a Lua function for SmartQuit
    local function smart_quit()
      if vim.bo.filetype == 'NvimTree' then
        -- Do nothing in NvimTree
        return
      else
        -- Use Bwipeout for other buffers
        try_bwipeout(false)
      end
    end
    
    -- Store the function globally so it can be called from command abbreviations
    _G.smart_quit = smart_quit
    
    -- Create custom commands instead of abbreviations to handle all cases
    vim.api.nvim_create_user_command('Q', function(opts)
      if opts.bang then
        -- Force quit without saving
        if vim.bo.filetype == 'NvimTree' then
          return
        else
          try_bwipeout(true)
        end
      else
        smart_quit()
      end
    end, { bang = true })
    
    vim.api.nvim_create_user_command('Wq', function(opts)
      vim.cmd('write')
      if opts.bang then
        if vim.bo.filetype == 'NvimTree' then
          return
        else
          try_bwipeout(true)
        end
      else
        smart_quit()
      end
    end, { bang = true })
    
    vim.api.nvim_create_user_command('Qa', function(opts)
      if opts.bang then
        -- Force quit all without saving
        vim.cmd('qa!')
      else
        -- Regular quit all
        vim.cmd('qa')
      end
    end, { bang = true })
    
    -- Create command abbreviations for lowercase versions
    vim.cmd('cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == "q" ? "Q" : "q"')
    vim.cmd('cnoreabbrev <expr> q! getcmdtype() == ":" && getcmdline() == "q!" ? "Q!" : "q!"')
    vim.cmd('cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "Wq" : "wq"')
    vim.cmd('cnoreabbrev <expr> wq! getcmdtype() == ":" && getcmdline() == "wq!" ? "Wq!" : "wq!"')
    vim.cmd('cnoreabbrev <expr> qa getcmdtype() == ":" && getcmdline() == "qa" ? "Qa" : "qa"')
    vim.cmd('cnoreabbrev <expr> qa! getcmdtype() == ":" && getcmdline() == "qa!" ? "Qa!" : "qa!"')
    
    -- Map Alt-Q to smart_quit
    vim.keymap.set('n', '<m-q>', function() smart_quit() end, { noremap = true, silent = true })
  end,
  desc = 'Setup smart quit commands after plugins are loaded'
})
