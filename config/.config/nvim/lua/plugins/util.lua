local dashboard = require("config.dashboard")

-- term_nav 関数を定義
local function term_nav(dir)
    return function()
        vim.cmd("wincmd " .. dir)
    end
end

return {
    {
        "folke/snacks.nvim",
        event = { "VimEnter" },
        opts = {
            dashboard = dashboard.opts,
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            terminal = {
                win = {
                    keys = {
                        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
                        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
                    },
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>.",   function() Snacks.scratch() end,                                                   desc = "Toggle Scratch Buffer" },
            { "<leader>S",   function() Snacks.scratch.select() end,                                            desc = "Select Scratch Buffer" },
            { "<leader>dps", function() Snacks.profiler.scratch() end,                                          desc = "Profiler Scratch Buffer" },
            { "<leader>ff",  function() Snacks.dashboard.pick("files") end,                                     { desc = "Find Config Files" } },
            { "<leader>fc",  function() Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config Files" } },
            { "<leader>gb",  function() Snacks.gitbrowse.open() end,  desc = "Open GitHub"  },
            { "<leader>gl",  function() Snacks.lazygit.open() end,  desc = "Open Lazygit"  },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find files' },
            { '<leader>fg', function() require('telescope.builtin').live_grep() end,  desc = 'Live grep' },
            { '<leader>fb', function() require('telescope.builtin').buffers() end,    desc = 'Buffers' },
            { '<leader>fh', function() require('telescope.builtin').help_tags() end,  desc = 'Help tags' },
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        event = {
            "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/**/*.md",
            "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/**/*.md",
        },
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope.nvim",
                config = function()
                    require("telescope").setup()
                end,
            },
        },
        opts = {
            workspaces = {
                {
                    name = "develop",
                    path = "~/ghq/github.com/noir-h/obsidian/develop", -- 絶対パス必須
                },
                {
                    name = "freee",
                    path = "~/ghq/github.com/noir-h/obsidian/freee", -- 絶対パス必須
                },
            },
            daily_notes = {
                folder = "daily",
                date_format = "%Y-%m-%d",
                alias_format = "%B %-d, %Y",
                template = nil,
            },
            -- Toggle check-boxes.
            ["<leader>ch"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            }
        },
    },

}
