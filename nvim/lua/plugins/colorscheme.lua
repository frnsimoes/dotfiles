return {
	"miikanissi/modus-themes.nvim",
	priority = 1000,
	config = function()
		require('modus-themes').setup({
			-- Style settings
		})

		-- Set the specific deuteranopia theme variant
		vim.cmd('colorscheme modus_vivendi')
	end
}
