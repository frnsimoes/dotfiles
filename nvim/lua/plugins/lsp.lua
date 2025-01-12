return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'ray-x/lsp_signature.nvim',
	},
	config = function()
		local capabilities = require('blink.cmp').get_lsp_capabilities()
		-- Basic LSP keymaps
		local on_attach = function(client, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
			end

			-- Setup signature help
			require('lsp_signature').on_attach({
				bind = true,
				handler_opts = {
					border = "rounded"
				},
				hint_enable = false,
				floating_window = true,
				toggle_key = '<C-k>',
			}, bufnr)

			map('gd', vim.lsp.buf.definition, 'Goto Definition')
			map('K', vim.lsp.buf.hover, 'Hover Documentation')
			map('rf', '<cmd>Telescope lsp_references<cr>', 'Show References')
			map('<leader>rn', vim.lsp.buf.rename, 'Rename')
			map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

			if client.server_capabilities.documentFormattingProvider then
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})
			end
		end

		-- Basic, non-intrusive diagnostics
		vim.diagnostic.config({
			virtual_text = {
				severity = { min = vim.diagnostic.severity.ERROR },
				spacing = 4,
				prefix = '●',
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Setup Mason
		require('mason').setup()
		require('mason-lspconfig').setup({
			ensure_installed = { 'gopls', 'pyright', 'lua_ls' },
			automatic_installation = true,
		})

		-- Configure LSP servers
		local lspconfig = require('lspconfig')
		local servers = {
			gopls = {},
			pyright = {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "off",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
							autoImports = true,
							importFormat = "absolute",
							autoImportCompletions = true,
						},
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' },
						},
					},
				},
			},
			terraform = {},
		}

		-- Setup servers
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			config.on_attach = on_attach
			lspconfig[server].setup(config)
		end
	end,
}
