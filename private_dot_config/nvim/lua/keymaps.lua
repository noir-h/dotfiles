-- Normal to Command
vim.keymap.set('n', ':', ';')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')

-- Insert to Command
vim.keymap.set('i', 'jj', '<ESC>')

-- window
vim.keymap.set('n', '<leader>h', '<C-w><C-h>')
vim.keymap.set('n', '<leader>j', '<C-w><C-j>')
vim.keymap.set('n', '<leader>k', '<C-w><C-k>')
vim.keymap.set('n', '<leader>l', '<C-w><C-l>')
vim.keymap.set('n', '<Return><Return>', '<C-w><C-w>')


