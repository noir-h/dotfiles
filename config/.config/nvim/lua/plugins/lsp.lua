return {
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
        config = function()
            require("config.mason")
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim" },
            { "neovim/nvim-lspconfig" },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = true,
        keys = {
            { "<C-space>", "<cmd>lua vim.lsp.completion.get()  <CR>", mode = "i" },
            { "gh",        "<cmd>lua vim.lsp.buf.hover()       <CR>" },
            { "gd",        "<cmd>lua vim.lsp.buf.definition()  <CR>" },
            { "gD",        "<cmd>lua vim.lsp.buf.declaration() <CR>" },
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

    -- print("opts function executed") -- 🚨 ここが表示されるか確認
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        dependencies = {
            "mason-org/mason.nvim",
            { "mason-org/mason-lspconfig.nvim", config = function() end },
        },
        opts = function()
            return require("config.lsp").opts -- `config/lsp.lua` の設定を適用
        end,
        config = function(_, opts)
            require("config.lsp").setup(opts) -- LSP の設定を適用
        end,
    },
}
