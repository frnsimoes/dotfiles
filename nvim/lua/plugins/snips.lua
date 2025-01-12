return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		event = "InsertEnter",
		config = function()
			local ls = require("luasnip")

			-- Set your snippets
			ls.add_snippets("python", {
				ls.snippet("ipd", {
					ls.text_node("import ipdb; ipdb.set_trace()")
				})
			})

			-- Keymaps
			vim.keymap.set({ "i" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { silent = true })
		end
	}
}
