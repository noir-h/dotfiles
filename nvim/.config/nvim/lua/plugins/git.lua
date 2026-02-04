return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre" },
        -- config = function() require("config.gitsigns").setup() end,
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Open Diffview" },
            { "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Close Diffview" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "All History" },
        },
        config = true,
    },
    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        opts = {
            -- or "fzf-lua" or "snacks" or "default"
            picker = "telescope",
            -- bare Octo command opens picker of commands
            enable_builtin = true,
        },
        keys = {
            {
                "<leader>oi",
                "<CMD>Octo issue list<CR>",
                desc = "List GitHub Issues",
            },
            {
                "<leader>op",
                "<CMD>Octo pr list<CR>",
                desc = "List GitHub PullRequests",
            },
            {
                "<leader>od",
                "<CMD>Octo discussion list<CR>",
                desc = "List GitHub Discussions",
            },
            {
                "<leader>on",
                "<CMD>Octo notification list<CR>",
                desc = "List GitHub Notifications",
            },
            {
                "<leader>os",
                function()
                    require("octo.utils").create_base_search_command { include_current_repo = true }
                end,
                desc = "Search GitHub",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            -- OR "ibhagwan/fzf-lua",
            -- OR "folke/snacks.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    }
}
