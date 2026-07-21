return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- Gutter signs for added / changed / removed lines.
		signs = {
			add          = { text = "│" },
			change       = { text = "│" },
			delete       = { text = "_" },
			topdelete    = { text = "‾" },
			changedelete = { text = "~" },
			untracked    = { text = "┆" },
		},
		current_line_blame = false, -- toggle at runtime with <leader>hb
		current_line_blame_opts = {
			delay = 300,
			virt_text_pos = "eol",
		},
	},
	config = function(_, opts)
		local gs = require("gitsigns")
		gs.setup(opts)

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
		end

		-- Navigate between hunks (changes).
		map("n", "]h", function() gs.nav_hunk("next") end, "Next git [H]unk")
		map("n", "[h", function() gs.nav_hunk("prev") end, "Prev git [H]unk")

		-- Visual diff actions.
		map("n", "<leader>hp", gs.preview_hunk, "[H]unk [P]review (inline diff)")
		map("n", "<leader>hd", gs.diffthis, "[H]unk [D]iff this file (side-by-side)")
		map("n", "<leader>hD", function() gs.diffthis("~") end, "[H]unk [D]iff vs last commit")

		-- Stage / reset hunks.
		map("n", "<leader>hs", gs.stage_hunk, "[H]unk [S]tage")
		map("n", "<leader>hr", gs.reset_hunk, "[H]unk [R]eset")
		map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[H]unk [S]tage (selection)")
		map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[H]unk [R]eset (selection)")

		-- Toggles.
		map("n", "<leader>hb", gs.toggle_current_line_blame, "[H]unk line [B]lame toggle")
		map("n", "<leader>ht", gs.toggle_deleted, "[H]unk show dele[T]ed toggle")
	end,
}
