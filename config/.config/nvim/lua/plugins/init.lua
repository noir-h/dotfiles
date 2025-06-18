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
        { import = "plugins.telescope" },
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
                -- 基本的な無効化プラグイン
                "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
                -- 起動速度最適化のための追加無効化
                "netrwPlugin",        -- ファイルエクスプローラー（yaziを使用）
                "matchit",            -- 括弧マッチング拡張（現代的な代替あり）
                "matchparen",         -- 括弧ハイライト（重い処理）
                "2html_plugin",       -- HTML変換（不要）
                "getscript",          -- スクリプト取得（不要）
                "getscriptPlugin",    -- スクリプト取得プラグイン（不要）
                "logipat",            -- ログパターン（不要）
                "rrhelper",           -- R言語ヘルパー（不要）
                "spellfile_plugin",   -- スペルファイル（必要時のみ有効化）
                "vimball",            -- vimballアーカイブ（不要）
                "vimballPlugin"       -- vimballプラグイン（不要）
            },
        },
    },
    -- debug = true,
})
