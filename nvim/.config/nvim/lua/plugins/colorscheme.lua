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
        event = "VimEnter",
        priority = 1000,
        config = function()
            require("config.onenord")
        end,
    },
}
