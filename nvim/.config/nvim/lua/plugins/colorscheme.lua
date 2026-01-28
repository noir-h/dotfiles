return {
    {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
            if (vim.g.colors_name or ""):find("catppuccin") then
                opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
            end
        end,
    },
    -- {
    --     "folke/tokyonight.nvim",
    --     event = "VeryLazy",
    --     opts = { style = "night" },
    --     config = function()
    --         vim.cmd.colorscheme("tokyonight-night")
    --     end,
    -- },
    {
        "rmehri01/onenord.nvim",
        lazy = false,
        priority = 1001,
        config = function()
            require("config.onenord")
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('kanagawa').setup({
                theme = "dragon", -- "wave", "dragon", "lotus"
                background = {    -- 背景のスタイル
                    dark = "dragon",
                    light = "lotus"
                },
                transparent = true, -- 背景を透過させたいなら true
                -- terminal_colors = true, -- ターミナルの色も合わせる
            })
            vim.cmd("colorscheme kanagawa")
        end,
    }
}
