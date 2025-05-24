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
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-cmdline',
        },
        config = function()
            local cmp = require('cmp')
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'path' },
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    },
                },
            })
        end
    },
}
