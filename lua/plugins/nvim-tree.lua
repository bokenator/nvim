local function on_attach(buffer_number)
	local api = require 'nvim-tree.api'

	local function get_options(description)
      return {
		  desc = 'nvim-tree: ' .. description,
		  buffer = buffer_number,
		  noremap = true,
		  silent = true,
		  nowait = true
	  }
    end

    api.config.mappings.default_on_attach(buffer_number)


    vim.keymap.set('n', 'l', api.node.open.edit, get_options('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, get_options('Close Directory'))
    vim.keymap.set('n', 'v', api.node.open.vertical, get_options('Open: Vertical Split'))
    vim.keymap.del('n', '<C-k>', { buffer = buffer_number })
    vim.keymap.set('n', '<S-k>', api.node.open.preview, get_options('Open Preview'))
end

local options = {
	noremap = true,
	silent = true,
}
-- Toggle
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', options)
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', options)
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', options)

require('nvim-tree').setup {
	on_attach = on_attach,
	sync_root_with_cwd = true,
}
