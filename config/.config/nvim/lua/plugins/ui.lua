return {
    {
        "nvim-lualine/lualine.nvim",
        event = { "VimEnter" },
        -- config = function() require("config.lualine").setup() end,
    },
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("barbar").setup({
                animation = true,      -- アニメーションを有効化
                auto_hide = false,     -- 1つのバッファだけの時も表示
                tabpages = true,       -- タブページごとにバッファを管理
                clickable = true,      -- タブをクリックで切り替え
                icons = {
                    buffer_index = true, -- バッファ番号を表示
                    filetype = { enabled = true }, -- ファイルタイプのアイコンを表示
                },
            })
        end,
    },
}
