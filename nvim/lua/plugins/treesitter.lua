return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup({})

		local ensure_installed = { "c", "lua", "python", "vim", "vimdoc", "query", "templ" }
		ts.install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("TreesitterSetup", {}),
			callback = function(args)
				local buf = args.buf
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not lang then
					return
				end

				local max_filesize = 200 * 1024
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return
				end

				if not pcall(vim.treesitter.start, buf, lang) then
					return
				end
			end,
		})
	end,
}
