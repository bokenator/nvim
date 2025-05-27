-- Buffer order management for lualine (must be defined before setup)
local buffer_order = {}  -- Stores custom buffer order

-- Initialize buffer order from current buffers
local function init_buffer_order()
	buffer_order = {}
	local buffers = vim.tbl_filter(function(buf)
		return buf.listed == 1
	end, vim.fn.getbufinfo())
	for _, buf in ipairs(buffers) do
		table.insert(buffer_order, buf.bufnr)
	end
end

-- Get current buffer's position in our custom order
local function get_buffer_position(bufnr)
	for i, buf in ipairs(buffer_order) do
		if buf == bufnr then
			return i
		end
	end
	return nil
end

-- Ensure buffer is in our order list
local function ensure_buffer_in_order(bufnr)
	if not get_buffer_position(bufnr) then
		table.insert(buffer_order, bufnr)
	end
end

-- Clean up deleted buffers from order
local function cleanup_buffer_order()
	local valid_buffers = {}
	for _, bufnr in ipairs(buffer_order) do
		if vim.fn.bufexists(bufnr) == 1 and vim.fn.getbufvar(bufnr, '&buflisted') == 1 then
			table.insert(valid_buffers, bufnr)
		end
	end
	buffer_order = valid_buffers
end

-- Move buffer in the order
local function move_buffer(direction)
	local current = vim.fn.bufnr()
	ensure_buffer_in_order(current)
	cleanup_buffer_order()
	
	local pos = get_buffer_position(current)
	if not pos then return end
	
	local new_pos = pos + direction
	
	-- Wrap around if at ends
	if new_pos < 1 then
		new_pos = #buffer_order
	elseif new_pos > #buffer_order then
		new_pos = 1
	end
	
	-- Swap positions
	buffer_order[pos], buffer_order[new_pos] = buffer_order[new_pos], buffer_order[pos]
	
	-- Force lualine to refresh
	vim.cmd('redrawstatus!')
	vim.cmd('redrawtabline')
end

-- Create a custom buffers component that uses our order
local buffers_component = require('lualine.components.buffers')
local CustomBuffers = buffers_component:extend()

function CustomBuffers:init(options)
	-- Set component_name to ensure highlights are created
	options.component_name = 'buffers'
	
	-- Call parent init
	buffers_component.init(self, options)
	
	-- Save reference to original buffers method
	local original_buffers = self.buffers
	
	-- Override the buffers method to use our custom order
	self.buffers = function(self_inner)
		cleanup_buffer_order()
		
		-- Get all listed buffers
		local all_buffers = vim.tbl_filter(function(buf)
			return buf.listed == 1
		end, vim.fn.getbufinfo())
		
		-- Ensure all buffers are in our order list
		for _, buf in ipairs(all_buffers) do
			ensure_buffer_in_order(buf.bufnr)
		end
		
		-- Create buffer objects in our custom order
		local buffers = {}
		local index = 1
		for _, bufnr in ipairs(buffer_order) do
			if vim.fn.buflisted(bufnr) == 1 and vim.api.nvim_buf_is_valid(bufnr) then
				buffers[index] = self:new_buffer(bufnr, index)
				index = index + 1
			end
		end
		
		return buffers
	end
end

-- Initialize on startup
vim.defer_fn(init_buffer_order, 100)

require('lualine').setup({
	options = {
		icons_enabled = true,
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		ignore_focus = { 'NvimTree' },
		globalstatus = true,
		disabled_filetypes = {
			statusline = { 'NvimTree' },
			winbar = { 'NvimTree' },
		},
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 10,
		},
		theme = 'auto',
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff' },
		lualine_c = { 'filename', 'location' },
		lualine_x = { 'diagnostics' },
		lualine_y = { 'filetype' },
		lualine_z = { 'progress' },
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				CustomBuffers,
				icons_enabled = true,
				colored = true,
				show_filename_only = true,
				hide_filename_extension = false,
				show_modified_status = true,
				mode = 0, -- 0: Shows buffer name
				max_length = vim.o.columns,
				use_mode_colors = false,
				buffers_color = {
					active = {
						gui = 'bold',
					},
					inactive = {
						fg = '#888888',
						gui = 'NONE',
					},
				},
				symbols = {
					modified = ' ●',
					alternate_file = '',
					directory = '',
				},
			}
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				CustomBuffers,
				icons_enabled = true,
				colored = true,
				show_filename_only = true,
				hide_filename_extension = false,
				show_modified_status = true,
				mode = 0, -- 0: Shows buffer name
				max_length = vim.o.columns,
				use_mode_colors = false,
				buffers_color = {
					active = {
						gui = 'bold',
						fg = '#ffffff',
					},
					inactive = {
						fg = '#888888',
						gui = 'NONE',
					},
				},
				symbols = {
					modified = ' ●',
					alternate_file = '',
					directory = '',
				},
			}
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	extensions = {
		'nvim-tree',
	},
})

local options = {
	noremap = true,
	silent = true,
}

-- Navigate to next/previous buffer in custom order
local function navigate_buffer(direction)
	local current = vim.fn.bufnr()
	ensure_buffer_in_order(current)
	cleanup_buffer_order()
	
	local pos = get_buffer_position(current)
	if not pos or #buffer_order <= 1 then return end
	
	local new_pos = pos + direction
	
	-- Wrap around if at ends
	if new_pos < 1 then
		new_pos = #buffer_order
	elseif new_pos > #buffer_order then
		new_pos = 1
	end
	
	-- Switch to the buffer at new position
	vim.cmd('buffer ' .. buffer_order[new_pos])
end

vim.keymap.set('n', '<m-s>', '<c-6>', options)  -- Alternate buffer
vim.keymap.set('n', '<m-n>', function() navigate_buffer(1) end, options)  -- Next buffer in custom order
vim.keymap.set('n', '<m-p>', function() navigate_buffer(-1) end, options)  -- Previous buffer in custom order
vim.keymap.set('n', '<m-N>', function() move_buffer(1) end, options)  -- Move buffer right
vim.keymap.set('n', '<m-P>', function() move_buffer(-1) end, options)  -- Move buffer left
-- For numbered buffer jumping (1-9)
for i = 1, 9 do
	vim.keymap.set('n', '<m-' .. i .. '>', ':LualineBuffersJump ' .. i .. '<CR>', options)
end

-- This autocmd ensures NvimTree windows have an empty statusline and winbar
vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = 'NvimTree',
	callback = function()
		vim.opt_local.statusline = ''
		vim.opt_local.winbar = ''
	end,
})
