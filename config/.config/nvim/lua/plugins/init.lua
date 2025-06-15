require("lazy").setup({
    spec = {
        { import = "plugins.editor" },
        { import = "plugins.lsp" },
        { import = "plugins.treesitter" },
        { import = "plugins.colorscheme" },
        { import = "plugins.git" },
        { import = "plugins.ui" },
        { import = "plugins.util" },
        { import = "plugins.treesitter" },
        { import = "plugins.explorer" },
        { import = "plugins.ai" },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true, notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
    -- debug = true,
})
