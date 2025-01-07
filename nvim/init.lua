-- Bootstrap the package manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.termguicolors = true

vim.opt.rtp:prepend(lazypath)

-- Load sets before loading plugins
require('set')

-- Load plugins
local lazy = require("lazy")
lazy.setup("plugins")

-- Load remaps before loading plugins
require('remap')

require("CopilotChat").setup {
	debug = true,
}

require('config.env')
