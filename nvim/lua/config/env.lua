local env = require('dotenv')
vim.api.nvim_create_user_command('LoadEnv', function()
	local env_vars = env.parse(vim.fn.getcwd() .. '/.env')
	for k, v in pairs(env_vars) do
		vim.env[k] = v
	end
	print('Environment variables loaded!')
end, {})
