local icons = require('config.icons')

require('ibl').setup({
	indent = {
		char = icons.ui.LineMiddle,
	},
	scope = {
		char = icons.ui.LineMiddle,
	},
	--context_char = icons.ui.LineMiddle,
	--show_trailing_blankline_indent = false,
	--show_first_indent_level = true,
	--use_treesitter = true,
	--show_current_context = true,
})
