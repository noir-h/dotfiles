local treesitter_config = require("config.treesitter")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- Windows で古いバージョンが動作しないため、最新を使用
    build = ":TSUpdate",
    event = { "BufNewFile", "BufReadPre" },
    lazy = vim.fn.argc(-1) == 0, -- コマンドラインでファイルを開いた場合は早めにロード
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    opts = treesitter_config.opts, -- 🔥 設定を config/treesitter.lua から読み込む
    config = function(_, opts)
      -- 🔥 `LazyVim.dedup()` の代わりに Neovim のテーブル関数を使う
      if type(opts.ensure_installed) == "table" then
        local seen = {}
        local unique_list = {}
        for _, item in ipairs(opts.ensure_installed) do
          if not seen[item] then
            table.insert(unique_list, item)
            seen[item] = true
          end
        end
        opts.ensure_installed = unique_list
      end

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
