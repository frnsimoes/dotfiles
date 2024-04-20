return {
	{
		'leoluz/nvim-dap-go',
		lazy = true,
		ft = "go",

		opts = {
			delve = {
				port = "40000",
			},

			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			}
		},
	},
}
-- return 	{
-- 	 	"leoluz/nvim-dap-go",
-- 	 	ft = "go",
-- 	 	dependencies = "mfussenegger/nvim-dap",
-- 	 	config = function(_, opts)
-- 		require("dap-go").setup{
-- 			dap_configurations = {
-- 				{
-- 					type = "go",
-- 					name = "Attach remote",
-- 					mode = "remote",
-- 					request = "attach",
-- 				},
-- 			},
-- 		}
-- 		end
-- 	}

