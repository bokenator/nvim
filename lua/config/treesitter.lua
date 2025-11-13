require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'javascript',
		'json',
		'lua',
		'markdown',
		'python',
		'rust',
		'toml',
		'typescript',
	},
	ignore_install = {
		'',
	},
	sync_install = false,
	highlight = {
		enable = true,
		disable = {
			'markdown',
		},
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = {
			'rust',
		}
	},
	autopairs = {
		enable = true,
	},
	textobjects = {
		lsp_interop = {
			enable = true,
			border = 'none',
			floating_preview_opts = {},
			peek_definition_code = {
				['<leader>df'] = '@function.outer',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']b'] = '@block.outer',
				[']m'] = '@function.outer',
				[']]'] = { query = '@class.outer', desc = 'Next class start' },
				--
				-- You can use regex matching (i.e. lua pattern) and/or pass a list in a 'query' key to group multiple queires.
				[']o'] = '@loop.*',
				-- [']o'] = { query = { '@loop.inner', '@loop.outer' } }
				--
				-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
				-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
				[']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
				[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
			-- Below will go to either the start or the end, whichever is closer.
			-- Use if you want more granular movements
			-- Make it even more gradual by adding multiple queries and regex.
			goto_next = {
				[']f'] = '@function.outer',
				[']F'] = '@function.inner',
				[']d'] = '@conditional.outer',
			},
			goto_previous = {
				['[f'] = '@function.outer',
				['[F'] = '@function.inner',
				['[d'] = '@conditional.outer',
			}
		},
		select = {
			enable = true,
			lookahead = true,		-- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['at'] = '@class.outer',
				['it'] = '@class.inner',
				['ac'] = '@call.outer',
				['ic'] = '@call.inner',
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['al'] = '@loop.outer',
				['il'] = '@loop.inner',
				['ai'] = '@conditional.outer',
				['ii'] = '@conditional.inner',
				['a/'] = '@comment.outer',
				['i/'] = '@comment.inner',
				['ab'] = '@block.outer',
				['ib'] = '@block.inner',
				['as'] = '@statement.outer',
				['is'] = '@scopename.inner',
				['aA'] = '@attribute.outer',
				['iA'] = '@attribute.inner',
				['aF'] = '@frame.outer',
				['iF'] = '@frame.inner',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	}
})

local repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

-- Make movement repeatable
vim.keymap.set({ 'n', 'x', 'o' }, ';', repeatable_move.repeat_last_move_next)
vim.keymap.set({ 'n', 'x', 'o' }, ',', repeatable_move.repeat_last_move_previous)

-- Make f, F, t, T also repeatable
local expr_opts = { expr = true, silent = true }
vim.keymap.set({ 'n', 'x', 'o' }, 'f', repeatable_move.builtin_f_expr, expr_opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'F', repeatable_move.builtin_F_expr, expr_opts)
vim.keymap.set({ 'n', 'x', 'o' }, 't', repeatable_move.builtin_t_expr, expr_opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'T', repeatable_move.builtin_T_expr, expr_opts)
