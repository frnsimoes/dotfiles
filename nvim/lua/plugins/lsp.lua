return {
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			vim.diagnostic.config({
				float = { border = "rounded" },
				virtual_text = true
			})

			vim.lsp.enable('clangd')
			vim.lsp.enable('lua_ls')
			vim.lsp.enable('ts_ls')
			vim.lsp.enable('eslint')
			vim.lsp.enable('golps')
			vim.lsp.enable('pyright')
			vim.lsp.enable('terraformls')
			vim.lsp.enable('yamlls')

			vim.keymap.set('n', '<c-k>', vim.lsp.buf.hover, {})
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<leader>fmt', vim.lsp.buf.format, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
			vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})

			vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, {})
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.goto_prev, {})
		end
	}
}
