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
			vim.lsp.enable('gopls')
			vim.lsp.enable('pyright')
			vim.lsp.enable('terraformls')
			vim.lsp.enable('yamlls')
			vim.lsp.enable('bashls')


			vim.keymap.set('n', '<c-k>', vim.lsp.buf.hover, {})
			
			-- LSP navigation with Telescope
			vim.keymap.set('n', 'gd', function() 
				require('telescope.builtin').lsp_definitions()
			end, { desc = "Go to definitions (Telescope)" })
			
			vim.keymap.set('n', 'gi', function() 
				require('telescope.builtin').lsp_implementations()
			end, { desc = "Go to implementations (Telescope)" })
			
			vim.keymap.set('n', 'gt', function() 
				require('telescope.builtin').lsp_type_definitions()
			end, { desc = "Go to type definitions (Telescope)" })
			
			vim.keymap.set('n', 'grr', function() 
				require('telescope.builtin').lsp_references()
			end, { desc = "Show references (Telescope)" })
			
			-- LSP symbols and diagnostics
			vim.keymap.set('n', '<leader>ds', function() 
				require('telescope.builtin').lsp_document_symbols()
			end, { desc = "Document symbols" })
			
			vim.keymap.set('n', '<leader>ws', function() 
				require('telescope.builtin').lsp_workspace_symbols()
			end, { desc = "Workspace symbols" })
			
			vim.keymap.set('n', '<leader>dd', function() 
				require('telescope.builtin').diagnostics({ bufnr = 0 })
			end, { desc = "Document diagnostics" })
			
			vim.keymap.set('n', '<leader>wd', function() 
				require('telescope.builtin').diagnostics()
			end, { desc = "Workspace diagnostics" })
			
			-- Other LSP actions (keeping original behavior)
			vim.keymap.set('n', '<leader>fmt', vim.lsp.buf.format, { desc = "Format document" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename symbol" })
			vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "Code actions" })

			vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, {})
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.goto_prev, {})
		end
	}
}
