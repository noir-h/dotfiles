# CLAUDE.md

## 言語設定
- 回答は日本語で行ってください

## プロジェクト情報
このディレクトリはNeovimの設定ファイルを管理しています。Lazy.nvimを使用したモジュラー構成で、効率的なプラグイン管理を実現しています。

## ディレクトリ構成

### ルートディレクトリ
- `init.lua`: Neovimのエントリーポイント（coreとlazyを読み込み）
- `lazy-lock.json`: Lazy.nvimのロックファイル（24個のプラグインのバージョン固定）
- `lazyvim.json`: LazyVim設定（現在はデフォルト設定）
- `stylua.toml`: Luaフォーマッター設定

### lua/core/（コア機能）
- `init.lua`: options, keymaps, autocmdsを一括読み込み
- `options.lua`: Neovimの基本設定（エンコーディング、表示、インデント等）
- `keymaps.lua`: キーマッピング設定（リーダーキー、バッファ操作等）
- `autocmds.lua`: 自動コマンド設定

### lua/config/（個別設定）
- `lazy.lua`: Lazy.nvimセットアップとプラグイン読み込み
- `dashboard.lua`: ダッシュボード設定
- `lsp_keymaps.lua`: LSPキーマッピング
- `lualine.lua`: ステータスライン設定
- `mason.lua`: LSPサーバー管理
- `onenord.lua`: カラーテーマ設定
- `treesitter.lua`: シンタックスハイライト設定
- `which-key.lua`: キーバインドヘルプ設定

### lua/plugins/（プラグイン管理）
- `init.lua`: プラグインの読み込み順序を定義
- `ai.lua`: AI関連プラグイン（Claude Code等）
- `colorscheme.lua`: カラーテーマプラグイン
- `editor.lua`: エディタ機能強化（which-key, gitsigns, comment）
- `explorer.lua`: ファイル探索機能
- `git.lua`: Git統合機能
- `lsp.lua`: LSP/補完/フォーマッター（Mason, nvim-lspconfig, conform.nvim）
- `treesitter.lua`: Tree-sitter設定
- `ui.lua`: UI要素（lualine, fidget, barbar）
- `util.lua`: ユーティリティプラグイン

### after/lsp/
- `lua_ls.lua`: Lua Language Server専用設定

## 主要プラグイン（24個）
- **エディタ**: which-key.nvim, Comment.nvim, gitsigns.nvim
- **LSP**: mason.nvim, nvim-lspconfig, mason-lspconfig.nvim
- **補完**: nvim-cmp, cmp-cmdline
- **フォーマッター**: conform.nvim
- **UI**: lualine.nvim, barbar.nvim, fidget.nvim
- **探索**: telescope.nvim, yazi.nvim
- **Git**: diffview.nvim, gitsigns.nvim
- **シンタックス**: nvim-treesitter
- **AI**: claude-code.nvim
- **その他**: lazy.nvim, plenary.nvim, snacks.nvim, obsidian.nvim

## 設定の特徴
- モジュラー構成でメンテナンス性が高い
- Lazy.nvimによる遅延読み込みで高速起動
- 日本語環境に最適化（ヘルプ、エンコーディング）
- プログラミング作業に特化したキーバインド
- LSPとTree-sitterによる高度な言語サポート

## 速度最適化のための推奨改善点

### 1. 起動速度の最適化
- **不要なプラグイン無効化をさらに拡張**: `lazy.lua:22-25`で一部無効化済みだが、以下も追加検討
  ```lua
  disabled_plugins = {
    "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
    "netrwPlugin", "matchit", "matchparen"  -- 追加候補
  }
  ```

### 2. Tree-sitter最適化
- **段階的インストール**: `treesitter.lua`で全言語を一度にインストールせず、必要に応じて遅延インストール
- **パーサーキャッシュ**: Tree-sitterパーサーのコンパイル結果をキャッシュ

### 3. LSP最適化
- **Mason遅延読み込み**: `lsp.lua:5`のcmdベース読み込みは良いが、初回起動時の自動インストールを制限
- **LSPサーバー起動制限**: プロジェクトタイプに応じて必要なLSPのみ起動
- **補完候補制限**: `cmp`の候補数制限や優先度調整

### 4. ファイル読み込み最適化
- **大ファイル検出**: 1MB以上のファイルでシンタックスハイライト無効化
- **バイナリファイル検出**: 自動検出して重い処理をスキップ

### 5. UI描画最適化
- **Lualine更新頻度調整**: ステータスライン更新間隔を調整
- **Barbar表示制限**: 開いているバッファ数が多い場合の表示最適化
- **Gitsigns差分計算**: 大きなファイルでの差分計算を制限

### 6. メモリ使用量最適化
- **プラグイン遅延読み込み**: 現在の`event`ベース読み込みをさらに細分化
- **未使用バッファクリーンアップ**: 一定時間未使用のバッファを自動クローズ

### 7. 実装推奨設定
```lua
-- lua/core/options.lua に追加推奨
vim.opt.lazyredraw = true        -- マクロ実行中の描画を抑制
vim.opt.regexpengine = 1         -- 正規表現エンジンを旧版に（高速）
vim.opt.synmaxcol = 300          -- シンタックスハイライトの列数制限
vim.opt.updatetime = 100         -- CursorHold イベントの間隔短縮

-- 大ファイル用autocmd例
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    if file_size > 1024 * 1024 then -- 1MB以上
      vim.opt_local.syntax = "off"
      vim.opt_local.foldenable = false
    end
  end,
})
```
