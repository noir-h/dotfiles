-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file
require('nvim-tree').setup {
  sort_by = 'extension',

  view = {
    width = '20%',
    side = 'right',
    signcolumn = 'no',
  },

  renderer = {
    highlight_git = true,
    highlight_opened_files = 'name',
    icons = {
      glyphs = {
        git = {
          unstaged = '!', renamed = '»', untracked = '?', deleted = '✘',
          staged = '✓', unmerged = '', ignored = '◌',
        },
      },
    },
  },

  actions = {
    expand_all = {
      max_folder_discovery = 100,
      exclude = { '.git', 'target', 'build' },
    },
  },

  on_attach = require('extensions.nvim-tree-actions').on_attach,
}

vim.api.nvim_set_keymap(
  "n", 
  "<leader>e", 
  "<cmd>NvimTreeToggle<CR>", 
  {
    noremap = true,
    silent = true,
    desc = "Toggle Nvim-Tree", 
  }
)