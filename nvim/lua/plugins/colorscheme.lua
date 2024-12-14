return {
	-- "catppuccin/nvim", name = "catppuccin", priority = 1000,
	-- config = function()
	-- 	vim.opt.background = "dark"
	-- 	vim.cmd.colorscheme "catppuccin"
	-- end,
	--
	{
		"bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd.colorscheme "moonfly"
		end,
	},
	

}
-- return {{
-- 	'minego/nvim-xenon',
--
-- 	-- Uncomment the following two lines when working with a local checkout
-- 	-- dir = "~/src/nvim-xenon",
-- 	-- dev = true,
--
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.opt.background = "dark"
-- 		vim.cmd.colorscheme "xenon"
-- 	end,
--
-- 	enabled = function()
-- 		return true
-- 	end,
-- }}
