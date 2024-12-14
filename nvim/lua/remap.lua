vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Avoid netrw remap
vim.api.nvim_set_keymap('n', '<leader>asdf', '<Plug>NetrwRefresh', {silent = true, nowait = true})

-- Navigate between windows
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Navigate to the left window' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Navigate to the left window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Navigate to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Navigate to the left window' })

-- Resize vsplit window mapping
vim.api.nvim_set_keymap('n', '<C-w>h', '<C-w><', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-w>l', '<C-w>>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-w>k', '<C-w>+', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-w>j', '<C-w>-', {noremap = true, silent = true})

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	desc = 'Highlight when yanking (copying) text',
	callback = function()
		vim.highlight.on_yank()
	end,
})

