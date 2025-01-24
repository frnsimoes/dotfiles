return {
	"tjdevries/colorbuddy.nvim",
	config = function()
		vim.cmd.colorscheme("gruvbuddy")

		-- Get colorbuddy components after theme is loaded
		local colorbuddy = require("colorbuddy")
		local Color = colorbuddy.Color
		local Group = colorbuddy.Group

		-- Create new white color
		Color.new("custom_white", "#fafafa")

		-- Set line numbers to our custom white
		Group.new("LineNr", colorbuddy.colors.custom_white, nil)
		Group.new("LineNrAbove", colorbuddy.colors.custom_white, nil)
		Group.new("LineNrBelow", colorbuddy.colors.custom_white, nil)
	end
}
