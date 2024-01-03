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

local icons = require('config.icons')

require('nvim-web-devicons').setup({})

require('nvim-tree').setup {
	on_attach = on_attach,
	sync_root_with_cwd = true,
	renderer = {
    	add_trailing = false,
    	group_empty = false,
    	highlight_git = false,
    	full_name = false,
    	highlight_opened_files = 'none',
    	root_folder_label = ':t',
    	indent_width = 2,
    	indent_markers = {
        	enable = false,
        	inline_arrows = true,
        	icons = {
          		corner = '└',
        		edge = '│',
        		item = '│',
        		none = ' ',
			},
		},
		icons = {
			git_placement = 'after',
			padding = ' ',
			symlink_arrow = ' ➛ ',
			glyphs = {
        		default = icons.ui.Text,
        		symlink = icons.ui.FileSymlink,
        		bookmark = icons.ui.BookMark,
        		folder = {
        			arrow_closed = icons.ui.ChevronRight,
            		arrow_open = icons.ui.ChevronShortDown,
            		default = icons.ui.Folder,
            		open = icons.ui.FolderOpen,
            		empty = icons.ui.EmptyFolder,
            		empty_open = icons.ui.EmptyFolderOpen,
            		symlink = icons.ui.FolderSymlink,
            		symlink_open = icons.ui.FolderOpen,
          		},
          		git = {
            		unstaged = icons.git.FileUnstaged,
            		staged = icons.git.FileStaged,
            		unmerged = icons.git.FileUnmerged,
            		renamed = icons.git.FileRenamed,
            		untracked = icons.git.FileUntracked,
            		deleted = icons.git.FileDeleted,
            		ignored = icons.git.FileIgnored,
          		},
        	},
		},
		special_files = {
			-- 'Cargo.toml',
			-- 'Makefile',
			-- 'README.md',
			-- 'readme.md'
		},
		symlink_destination = true,
	},
	update_focused_file = {
		enable = true,
		debounce_delay = 15,
		update_root = true,
		ignore_list = {},
	},
	git = {
	   enable = true,
	   ignore = false,
	   timeout = 500,
   },
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		debounce_delay = 50,
		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
		icons = {
			hint = icons.diagnostics.BoldHint,
			info = icons.diagnostics.BoldInformation,
			warning = icons.diagnostics.BoldWarning,
			error = icons.diagnostics.BoldError,
		},
	},
}
