return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
				show_hidden_count = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_by_name = {},
			},
			follow_current_file = {
				enable = true,
				leave_dirs_open = false,
			},
			window = {
				mappings = {
					["Y"] = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
						vim.notify("Copied: " .. path)
					end,
				},
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.api.nvim_set_keymap('n', '<C-b>', ':Neotree<CR>', { noremap = true, silent = true })
	end,
}
