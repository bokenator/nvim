local icons = require('config.icons')

require('ibl').setup({
	indent = {
		char = icons.ui.LineLeft,
	},
	scope = {
		enabled = false,
	},
})
