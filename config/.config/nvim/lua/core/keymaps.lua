local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

map("n", "<Tab>", "<Cmd>BufferNext<CR>", opts) -- 次のバッファ
map("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts) -- 前のバッファ
map("n", "<leader>bc", "<Cmd>BufferClose<CR>", opts) -- 現在のバッファを閉じる
map("n", "<leader>bo", "<Cmd>BufferCloseAllButCurrent<CR>", opts) -- 現在のバッファ以外を閉じる
map("n", "<leader>bp", "<Cmd>BufferMovePrevious<CR>", opts) -- 左へ移動
map("n", "<leader>bn", "<Cmd>BufferMoveNext<CR>", opts) -- 右へ移動


-- This file is automatically loaded by plugins.core
-- Normal to Command
vim.keymap.set('n', ':', ';')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')
vim.keymap.set('n', 'p', 'p`]', { desc = 'Paste and move to the end' })
vim.keymap.set('n', 'P', 'P`]', { desc = 'Paste and move to the end' })

vim.keymap.set('x', 'p', 'P', { desc = 'Paste without change register' })
vim.keymap.set('x', 'P', 'p', { desc = 'Paste with change register' })

-- Insert to Command
vim.keymap.set('i', 'jj', '<ESC>')

-- window
-- vim.keymap.set('n', '<leader>h', '<C-w><C-h>')
-- vim.keymap.set('n', '<leader>j', '<C-w><C-j>')
-- vim.keymap.set('n', '<leader>k', '<C-w><C-k>')
-- vim.keymap.set('n', '<leader>l', '<C-w><C-l>')
vim.keymap.set('n', '<leader><Return><Return>', '<C-w><C-w>')
