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
        "stevearc/conform.nvim",
        config = function()
            local web_formatter = { "prettier", stop_after_first = true }
            require("conform").setup({
                formatters_by_ft = {
                    typescript = web_formatter,
                    javascript = web_formatter,
                    typescriptreact = web_formatter,
                    javascriptreact = web_formatter,
                    vue = web_formatter,
                    svelte = web_formatter,
                    json = web_formatter,
                    jsonc = web_formatter,
                    yaml = web_formatter,
                    html = web_formatter,
                    css = web_formatter,
                    scss = web_formatter,
                    less = web_formatter,
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
                -- Prettier の設定をカスタマイズする場合
                formatters = {
                    prettier = {
                        -- ルートディレクトリの .prettierrc.js などの設定ファイルを優先して使用
                        prepend_args = { "--config-precedence", "prefer-file" },
                        -- または特定の設定を直接指定することもできます
                        -- args = { "--single-quote", "--trailing-comma", "es5" },
                    }
                },
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup.cmdline(":", {
                -- mapping = cmp.mapping.preset.cmdline(),
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(), -- 次の候補
                    ['<C-p>'] = cmp.mapping.select_prev_item(), -- 前の候補
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    -- 他のマッピングも必要に応じて...
                },
                sources = cmp.config.sources({
                    { name = "path" },
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
        end,
    },
}
