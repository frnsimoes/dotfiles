return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    config = function()
        -- Basic LSP keymaps
        local on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
            end

            -- Essential keymaps only
            map('gd', vim.lsp.buf.definition, 'Goto Definition')
            map('K', vim.lsp.buf.hover, 'Hover Documentation')
            map('<leader>rn', vim.lsp.buf.rename, 'Rename')
            map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        end

        -- Setup Mason to automatically install LSPs
        require('mason').setup()
        require('mason-lspconfig').setup()

        -- Configure LSP servers
        local lspconfig = require('lspconfig')
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Your essential LSP servers
        local servers = {
            'gopls',        -- Go
            'pyright',      -- Python
            'lua_ls',       -- Lua
        }

        -- Simple LSP server setup
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end
    end,
}
