return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'hrsh7th/nvim-cmp', -- Autocompletion plugin
		'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
		'hrsh7th/cmp-buffer', -- Buffer completions
		'hrsh7th/cmp-path', -- Path completions
	},
	config = function()
		-- Enhanced capabilities for autocompletion
		local capabilities = require('cmp_nvim_lsp').default_capabilities()

		-- Basic LSP keymaps
		local on_attach = function(client, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
			end

			map('gd', vim.lsp.buf.definition, 'Goto Definition')
			map('K', vim.lsp.buf.hover, 'Hover Documentation')
			map('rf', '<cmd>Telescope lsp_references<cr>', 'Show References')
			map('<leader>rn', vim.lsp.buf.rename, 'Rename')
			map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

			-- Should I keep this?
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

		-- Setup nvim-cmp
		local cmp = require('cmp')
		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				['<C-Space>'] = cmp.mapping.complete(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<Tab>'] = cmp.mapping.select_next_item(),
				['<S-Tab>'] = cmp.mapping.select_prev_item(),
			}),
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'buffer' },
				{ name = 'path' },
			},
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
		}

		-- Setup servers
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			config.on_attach = on_attach
			lspconfig[server].setup(config)
		end
	end,
}
