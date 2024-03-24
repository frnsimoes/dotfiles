return {
		"mfussenegger/nvim-dap",

		dependencies = {
			'folke/which-key.nvim',
			'nvim-telescope/telescope-dap.nvim',
		},

		config = function()
			vim.keymap.set('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>')
			vim.keymap.set('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
			vim.keymap.set('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>')
			vim.keymap.set('n', '<leader>do', '<cmd>lua require"dap".step_over()<CR>')
			vim.keymap.set('n', '<leader>dcb', '<cmd>lua require"dap".clear_breakpoints()<CR>')
		end,
}


