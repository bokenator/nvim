-- package.path = package.path .. ";/root/.config/nvim/?.lua"
directory = debug.getinfo(1, 'S').source:sub(2):match('^(.*[/\\])')
package.path = package.path .. ';' .. directory .. '?.lua'

require('./autopairs')
require('./bufdelete')
require('./colorscheme')
require('./comment')
require('./editor')
require('./icons')
require('./keymaps')
require('./lspconfig')
require('./tree')
require('./treesitter')

