return {
  -- The core plugin for a supercharged Rust LSP experience
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended major version
    lazy = false,   -- This plugin already handles lazy loading internally
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- You can define your specific LSP keymaps here
            local bufopts = { silent = true, buffer = bufnr }
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end, bufopts)
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        },
      }
    end
  },

  -- Optional: Auto-completion engine 
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim-lspconfig' },
        }),
      })
    end
  }
}
