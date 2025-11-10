vim.g.mapleader = ' '

-- Tab and indentation settings (4 spaces)
vim.opt.tabstop = 4        -- Number of spaces a tab character represents
vim.opt.softtabstop = 4    -- Number of spaces to use when inserting a tab
vim.opt.shiftwidth = 4     -- Number of spaces for indentation
vim.opt.expandtab = true   -- Convert tabs to spaces

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

-- accent colorscheme config
vim.g.accent_colour = 'blue'
vim.g.accent_darken = 1

-- Enable autoread
vim.o.autoread = true

-- Trigger `checktime` when switching buffers or focusing Neovim
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = "*",
})

vim.keymap.set('c', '<Tab>', '<C-z>')
