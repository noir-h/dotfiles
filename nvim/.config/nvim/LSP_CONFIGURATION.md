# Neovim LSP 設定ガイド

## 全体構成

```
lua/plugins/lsp.lua          … プラグイン定義（Mason, nvim-lspconfig, conform, cmp）
lua/config/mason.lua         … Mason によるサーバーの自動インストール
lua/config/lsp_keymaps.lua   … vim.lsp.enable() + LspAttach 時のキーマップ・診断設定
after/lsp/                   … Neovim 0.11+ 組み込みのサーバー固有設定（自動読み込み）
  ├─ lua_ls.lua
  ├─ clangd.lua
  └─ rust_analyzer.lua
```

## 各ファイルの役割

### `lua/plugins/lsp.lua` — プラグイン定義

Lazy.nvim で LSP 関連プラグインを管理する。`mason-lspconfig.nvim` が `BufReadPre`/`BufNewFile` で遅延読み込みされ、依存する `mason.nvim` と `nvim-lspconfig` も同時に初期化される。

### `lua/config/mason.lua` — サーバーインストール管理

```lua
require 'mason'.setup()

local ensure_installed = { 'lua_ls', 'gopls', 'clangd' }
require 'mason-lspconfig'.setup {
    automatic_installation = true,
    ensure_installed = ensure_installed,
}
```

`ensure_installed` に列挙したサーバーが Mason 経由で自動インストールされる。

### `lua/config/lsp_keymaps.lua` — サーバー有効化 & 共通キーマップ

ファイル先頭で **`vim.lsp.enable()`** を呼び、LSP サーバーを宣言的に有効化する。

```lua
vim.lsp.enable({ "lua_ls", "gopls", "clangd" })
```

`M.setup()` 内で `LspAttach` autocmd を登録し、サーバー接続時に以下を設定する。

| キー | 機能 | 条件 |
|------|------|------|
| `gd` | 定義ジャンプ | `textDocument/definition` |
| `gD` | 宣言ジャンプ | `textDocument/declaration` |
| `gh` | ホバー表示 | `textDocument/hover` |
| `gr` | 参照一覧 | — |
| `gi` | 実装一覧 (Telescope) | — |
| `gl` | 行診断表示 | — |
| `gtd` | 型定義ジャンプ | — |
| `<Space>la` | コードアクション | — |
| `<Space>lf` | フォーマット | `textDocument/formatting` |
| `<Space>lr` | リネーム | `textDocument/rename` |

また、`textDocument/formatting` をサポートするサーバー（`ts_ls` を除く）は `BufWritePre` で自動フォーマットを実行する。`textDocument/completion` 対応サーバーでは `vim.lsp.completion.enable()` による組み込み補完も有効化される。

### `after/lsp/*.lua` — サーバー固有設定（Neovim 0.11+ 組み込み機能）

**`after/lsp/` は nvim-lspconfig の機能ではなく、Neovim 0.11+ の組み込み機能**。ファイル名がサーバー名と一致する Lua ファイルを自動で読み込み、`return` されたテーブルをサーバー設定にマージする。

#### `after/lsp/lua_ls.lua`

```lua
return {
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            hint = { enable = true, paramType = true },
        },
    }
}
```

#### `after/lsp/clangd.lua`

```lua
return {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    settings = {
        clangd = {},
    },
}
```

#### `after/lsp/rust_analyzer.lua`

```lua
return {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
            completion = {
                autoimport = { enable = true },
                privateEditable = { enable = false },
                limit = 50,
            },
        },
    },
}
```

## LSP サーバー追加手順

新しいサーバー（例: `pyright`）を追加する 3 ステップ:

1. **`lua/config/mason.lua`** の `ensure_installed` に `'pyright'` を追加
2. **`lua/config/lsp_keymaps.lua`** の `vim.lsp.enable()` に `"pyright"` を追加
3. （任意）**`after/lsp/pyright.lua`** を作成し、サーバー固有設定を `return {}` で記述
