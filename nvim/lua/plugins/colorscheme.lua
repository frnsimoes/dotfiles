--return {
--    'AlexvZyl/nordic.nvim',
--    lazy = false,
--    priority = 1000,
--    config = function()
--        require 'nordic' .load()
--    end
--}
--
-- return {
-- 	"ful1e5/onedark.nvim",
-- 	config = function()
-- 		require('onedark').setup()
-- 	end
-- }
 return {{
 	'frnsimoes/nvim-xenon',

 	-- uncomment the following two lines when working with a local checkout
 	-- dir = "~/src/nvim-xenon",
 	-- dev = true,

 	lazy = false,
 	priority = 1000,
 	config = function()
 		vim.opt.background = "dark"
 		vim.cmd.colorscheme "xenon"
 	end,

 	enabled = function()
 		return true
 	end,
 }}
--return { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000,
--
--	config = function()
--		vim.cmd.colorscheme "midnight"
--	end,
--}
--

--return {
--	'Iron-E/nvim-highlite',
--		config = function(_, opts)
--			-- OPTIONAL: setup the plugin. See "Configuration" for information
--			require('highlite').setup {generator = {plugins = {vim = false}, syntax = false}}
--
--			-- or one of the alternate colorschemes (see the "Built-in Colorschemes" section)
--			vim.api.nvim_command 'colorscheme highlite-molokai'
--		end,
--		lazy = false,
--		priority = math.huge,
--		version = '^4.0.0',
--	}
--
