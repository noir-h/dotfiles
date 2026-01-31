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
            { "<leader>fc",  function() Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") }) end, desc = "Find Config Files" },
            { "<leader>gb",  function() Snacks.gitbrowse.open() end,                                            desc = "Open GitHub" },
            { "<leader>gl",  function() Snacks.lazygit.open() end,                                              desc = "Open Lazygit" },
        },
    },

    {
        "renerocksai/telekasten.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "renerocksai/calendar-vim",
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>zn", function() require("telekasten").new_note() end,     desc = "New note" },
            { "<leader>zf", function() require("telekasten").find_notes() end,   desc = "Find notes" },
            { "<leader>zg", function() require("telekasten").search_notes() end, desc = "Grep notes" },
            { "<leader>zd", function() require("telekasten").goto_today() end,   desc = "Today note" },
            { "<leader>zz", function() require("telekasten").follow_link() end,  desc = "Follow link" },
        },
        config = function()
            require("telekasten").setup({
                home = vim.fn.expand("/Users/igarashisora/ghq/github.com/noir-h/zettelkasten"),
            })
        end,
    },
}
