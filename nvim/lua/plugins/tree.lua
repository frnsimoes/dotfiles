return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
				show_hidden_count = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_by_name = {
					-- '.git',
					-- '.DS_Store',
					-- 'thumbs.db',
				},
			},
			follow_current_file = {
				enable = true,
				leave_dirs_open = false,
			},
		},
	},
	config = function()
		vim.api.nvim_set_keymap('n', '<C-b>', ':Neotree<CR>', {noremap = true, silent = true})
	end
}
