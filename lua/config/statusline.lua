require('lualine').setup({
	options = {
		component_separators = { left = '', right = ''},
	    section_separators = { left = '', right = ''},
		ignore_focus = { 'NvimTree' },
		globalstatus = false,
		disabled_filetypes = {
			statusline = { 'NvimTree' },
			winbar = { 'NvimTree' },
		},
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff' },
		lualine_c = {
			{'filename', show_filename_only = false},
			'location',
		},
		lualine_x = { 'diagnostics' },
		lualine_y = { 'filetype' },
		lualine_z = { 'progress' },
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'buffers'},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	extensions = {
		'nvim-tree',
	},
})
