return {
	{
		"bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd.colorscheme "moonfly"
		end,
	},
}
