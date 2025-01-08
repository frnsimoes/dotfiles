vim.g.mapleader = ' '

--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Make line numbers default
vim.opt.number = true

vim.opt.swapfile = false

-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

vim.opt.hlsearch = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'


vim.opt.cmdheight = 1             -- Ensure command line has height
vim.opt.wildoptions:remove("pum") -- Remove popup menu from wild menu
