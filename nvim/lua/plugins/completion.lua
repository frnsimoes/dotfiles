return { 
	'saghen/blink.cmp', 
	dependencies = 'rafamadriz/friendly-snippets', 
	version = '*', 
	opts = { 
		keymap = { preset = 'default' }, 
		appearance = { 
			use_nvim_cmp_as_default = true, 
			nerd_font_variant = 'mono' 
		},
		sources = {
			default = function()
				if vim.bo.filetype == 'markdown' then
					return {}
				end
				return { 'lsp', 'path', 'snippets', 'buffer' }
			end
		}
	}, 
	opts_extend = { "sources.default" } 
}
