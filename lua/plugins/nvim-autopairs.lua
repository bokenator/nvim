require('nvim-autopairs').setup({
	map_char = {
		all = '(',
		tex = '{',
	},
	enable_check_bracket_line = false,
	check_ts = true,
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),
	enable_moveright = true,
	enable_afterquote = true,  			-- Add bracket pairs after quote
	enable_check_bracket_line = true,  	-- Check bracket in same line
	enable_bracket_in_quote = true,
	enable_abbr = false, 				-- Trigger abbreviation
	break_undo = true,					-- Switch for basic rule break undo sequence
	check_ts = false,
	map_cr = true,
	map_bs = true,						-- Map the <BS> key
	map_c_h = false,					-- Map the <C-h> key to delete a pair
	map_c_w = false,					-- Map <c-w> to delete a pair if possible
})
