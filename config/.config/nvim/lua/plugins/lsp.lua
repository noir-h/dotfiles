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
            {
                "neovim/nvim-lspconfig",
                config = function()
                    require("config.lsp_keymaps").setup()
                end
            },
        },
        event = { "BufReadPre", "BufNewFile" },
        -- config = true,
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
}
