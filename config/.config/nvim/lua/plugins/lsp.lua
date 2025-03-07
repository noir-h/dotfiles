return {
    -- Mason (LSP, DAP, Linter, Formatter の管理)
    {
        "williamboman/mason.nvim",
        lazy = false, -- Neovim 起動時にロード
        config = function()
            require("config.mason")
        end,
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
        },
        config = function()
          require("config.cmp")
        end,
      },


    -- Mason-LSPconfig (Mason + LSP の連携)
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                -- ensure_installed = { -- 🔥 ここで自動インストールする LSP を指定
                --   "lua_ls",
                --   "tsserver",
                --   "pyright",
                --   "rust_analyzer",
                --   "gopls",
                --   "html",
                --   "cssls",
                --   "bashls",
                --   "jsonls",
                -- },
                automatic_installation = true, -- 必要な LSP を自動インストール
            })
        end,
    },

    -- print("opts function executed") -- 🚨 ここが表示されるか確認
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        dependencies = {
            "williamboman/mason.nvim",
            { "williamboman/mason-lspconfig.nvim", config = function() end },
        },
        opts = function()
            return require("config.lsp").opts -- `config/lsp.lua` の設定を適用
        end,
        config = function(_, opts)
            require("config.lsp").setup(opts) -- LSP の設定を適用
        end,
    },
}
