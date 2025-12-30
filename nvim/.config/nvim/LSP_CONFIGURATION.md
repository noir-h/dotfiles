# Neovim LSP設定の構造解説

このドキュメントでは、本Neovim設定におけるLSP（Language Server Protocol）の実装構造を詳しく解説します。

## 📚 目次

1. [全体構成](#全体構成)
2. [4層アーキテクチャ](#4層アーキテクチャ)
3. [`after/lsp/`ディレクトリの役割](#afterlspディレクトリの役割)
4. [読み込みシーケンス](#読み込みシーケンス)
5. [各ファイルの詳細](#各ファイルの詳細)
6. [設計の利点](#設計の利点)

---

## 全体構成

本Neovim設定のLSPシステムは、複数のコンポーネントが連携して動作する**4層構造**で構成されています。

```
init.lua (エントリーポイント)
  ↓
lua/plugins/lsp.lua (プラグイン定義層)
  ├─ Mason.nvim
  ├─ mason-lspconfig.nvim
  ├─ nvim-lspconfig
  ├─ conform.nvim
  └─ nvim-cmp
  ↓
lua/config/mason.lua (サーバー管理層)
  └─ LSPサーバーのインストール・起動管理
  ↓
lua/config/lsp_keymaps.lua (イベント処理層)
  └─ キーマップ・診断・補完の設定
  ↓
after/lsp/*.lua (サーバー固有設定層) ⭐
  ├─ lua_ls.lua
  └─ rust_analyzer.lua
```

---

## 4層アーキテクチャ

### 層1: プラグイン定義層（`lua/plugins/lsp.lua`）

**責務**: LSP関連プラグインの依存関係と読み込みタイミングを定義

**主要なプラグイン**:
- `mason.nvim` - LSPサーバー管理UI
- `mason-lspconfig.nvim` - MasonとLSPの橋渡し
- `nvim-lspconfig` - LSP設定の核
- `conform.nvim` - フォーマッター
- `nvim-cmp` - 補完エンジン

**特徴**:
```lua
-- 遅延読み込みで起動速度を最適化
event = { "BufReadPre", "BufNewFile" }  -- ファイル開く時に初期化
```

### 層2: サーバー管理層（`lua/config/mason.lua`）

**責務**: Masonを通じたLSPサーバーの自動インストール管理

**主要な設定**:
```lua
local ensure_installed = { 'ts_ls', 'lua_ls', 'gopls' }
```

これら3つのLSPサーバーは自動的にインストールされます。

**機能**:
- `automatic_installation = true` により、新しい言語ファイルを開くと対応するLSPが自動インストール可能

### 層3: イベント処理層（`lua/config/lsp_keymaps.lua`）

**責務**: 全LSPサーバー共通のキーマップとイベントハンドラー設定

**実行タイミング**: `LspAttach`イベント発火時（LSPサーバーがバッファに接続される時）

**主要な設定内容**:

#### 診断表示設定
```lua
vim.diagnostic.config({
    virtual_text = { spacing = 4 },
    signs = true,
    underline = true,
    update_in_insert = false,
})
```

#### キーマップ設定
| キー | 機能 | 実装 |
|------|------|------|
| `gh` | ホバー情報表示 | `vim.lsp.buf.hover` |
| `gd` | 定義へジャンプ | `vim.lsp.buf.definition` |
| `gi` | 実装へジャンプ | `telescope.lsp_implementations` |
| `gr` | 参照検索 | `telescope.lsp_references` |
| `gn` | リネーム | `vim.lsp.buf.rename` |

#### 自動フォーマット設定
```lua
-- BufWritePre時にLSPによる自動フォーマット実行
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
```

### 層4: サーバー固有設定層（`after/lsp/*.lua`） ⭐

**責務**: 個別LSPサーバーの詳細なカスタマイズ

**現在の設定ファイル**:
- `after/lsp/lua_ls.lua` - Lua Language Server専用設定
- `after/lsp/rust_analyzer.lua` - Rust Analyzer専用設定

---

## `after/lsp/`ディレクトリの役割

### Neovimの`after/`ディレクトリとは？

`after/` は、Neovimのランタイムパス機構における**特別なディレクトリ**で、他のすべての設定が読み込まれた後に実行されます。

**読み込み順序**:
```
1. runtimepathの設定
2. プラグインディレクトリの読み込み（plugin/）
3. ユーザー設定（init.lua、config/）
4. ✨ after/ ディレクトリ（遅延実行）← ここ！
```

### なぜ`after/lsp/`を使うのか？

#### 問題: 汎用設定と言語固有設定の混在

すべての設定を`lua/config/`に書くと：
- ファイルが肥大化
- 言語固有の設定が散在
- 保守性の低下

#### 解決: 責務の分離

```
lua/config/lsp_keymaps.lua          after/lsp/lua_ls.lua
├─ 全LSPサーバー共通              vs  ├─ Lua専用の詳細設定
├─ キーマップ（gh, gd, gi...）        ├─ workspace設定
├─ 診断表示                           ├─ 補完スニペット設定
├─ 自動フォーマット                   ├─ インラインヒント
└─ 汎用的な動作                       └─ サードパーティチェック
```

### 自動発見メカニズム

nvim-lspconfigは**ファイル名とLSPサーバー名の一致**を検出して、自動的に設定を読み込みます：

```
LSPサーバー起動時の処理:

1. nvim-lspconfigがサーバー名を確認（例: lua_ls）
2. ランタイムパスから after/lsp/lua_ls.lua を検索
3. 見つかった場合、そのファイルを読み込み
4. デフォルト設定とマージ
5. LSPサーバーに最終的な設定を適用
```

**具体例**:
- `lua_ls` サーバー起動 → `after/lsp/lua_ls.lua` を検索・読み込み
- `rust_analyzer` 起動 → `after/lsp/rust_analyzer.lua` を検索・読み込み
- `gopls` 起動 → `after/lsp/gopls.lua` を検索（なければスキップ）

### 設定のマージ方式

```lua
-- nvim-lspconfigのデフォルト設定
lua_ls = {
    cmd = { "lua-language-server" },
    settings = { ... }  -- デフォルト設定
}

-- after/lsp/lua_ls.lua で上書き・拡張
{
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },  -- 追加・上書き
            completion = { callSnippet = "Replace" },
            hint = { enable = true },
        }
    }
}

-- 最終的な設定 = デフォルト + カスタム設定の統合
```

---

## 読み込みシーケンス

### タイムライン詳細

```
時刻0: Neovim起動
  ├─ init.lua読み込み
  ├─ core/（基本設定）読み込み
  ├─ config/lazy.lua読み込み
  │   └─ Lazy.nvim初期化
  └─ plugins/init.lua読み込み
       └─ plugins/lsp.luaをspecに追加

時刻1: plugins/lsp.luaの評価（プラグイン定義）
  ├─ Mason.nvim: cmd指定で遅延
  ├─ Mason-lspconfig.nvim: event指定で遅延
  ├─ nvim-cmp, conform.nvim登録
  └─ 待機状態

時刻2: ファイルを開く（例: test.lua）
  ├─ BufReadPre イベント発火
  ├─ mason-lspconfig.nvim読み込み
  ├─ lua/config/mason.lua実行
  │   └─ Mason.setup() + ensure_installed実行
  ├─ nvim-lspconfig読み込み
  └─ lua/config/lsp_keymaps.lua読み込み
       └─ setup()実行（LspAttach イベントリスナー登録のみ）

時刻3: Mason-lspconfigの自動初期化処理
  ├─ 対応するLSPサーバー検出（lua_ls）
  ├─ サーバー起動プロセス開始
  └─ ⭐ after/lsp/lua_ls.lua 自動読み込み（設定適用）

時刻4: LSPサーバーがバッファに接続
  ├─ LspAttachイベント発火
  ├─ lua/config/lsp_keymaps.luaのコールバック実行
  │   ├─ キーマップ設定（gh, gd, gi等）
  │   ├─ 自動フォーマット設定
  │   ├─ 補完トリガー設定
  │   └─ 診断表示設定
  └─ エディタで使用可能に ✅
```

### 処理フロー図

```
ファイルオープン
    ↓
LSPサーバー検出
    ↓
[nvim-lspconfig] デフォルト設定読み込み
    ↓
[after/lsp/] カスタム設定マージ ← ここが重要！
    ↓
LSPサーバー起動
    ↓
LspAttachイベント
    ↓
キーマップ・診断設定
    ↓
使用可能
```

---

## 各ファイルの詳細

### `after/lsp/lua_ls.lua`

**目的**: Lua Language Serverの動作を最適化

**設定内容**:
```lua
require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            -- 外部ライブラリの自動検出を無効化（Neovim設定ファイルで誤警告を防ぐ）
            workspace = {
                checkThirdParty = false,
            },

            -- 補完時にスニペットを置換
            completion = {
                callSnippet = "Replace",
            },

            -- インラインヒント表示を有効化
            hint = {
                enable = true,
                paramType = true,    -- パラメータ型を表示
                setType = true,      -- 変数型を表示
            },

            -- 診断設定
            diagnostics = {
                globals = { 'vim' },  -- 'vim' グローバル変数を認識
            },
        },
    },
})
```

**効果**:
- Neovim設定ファイルで `vim` が未定義エラーにならない
- 関数呼び出し時に引数のヒントが表示される
- より正確な補完候補が提示される

### `after/lsp/rust_analyzer.lua`

**目的**: Rust Analyzerの高度な機能を有効化

**設定内容**:
```lua
require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            -- Clippyによる高度な検査（デフォルトのcheckより厳格）
            check = {
                command = "clippy",
                allTargets = true,
            },

            -- プロシージャルマクロのサポート
            procMacro = {
                enable = true,
            },

            -- インラインヒント（型情報・パラメータ名）
            inlayHints = {
                enable = true,
                chainingHints = true,         -- メソッドチェーンの型
                parameterHints = true,        -- パラメータ名
                typeHints = true,             -- 変数の型
            },

            -- 実験的な診断機能
            diagnostics = {
                experimental = {
                    enable = true,
                },
            },
        },
    },
})
```

**効果**:
- Clippyによる厳格なコードチェック
- マクロの展開・補完が正しく動作
- 型推論結果がインラインで表示される
- より詳細なエラー診断

---

## 設計の利点

### 1. 拡張性

新しいLSPサーバーを追加する際の手順：

```bash
# 1. after/lsp/ディレクトリに新しい設定ファイルを作成
touch after/lsp/gopls.lua

# 2. 設定を記述
# require("lspconfig").gopls.setup({ ... })

# 3. 終わり！自動的に読み込まれます
```

**手動でrequireする必要がありません**。ファイル名とサーバー名が一致していれば、nvim-lspconfigが自動検出します。

### 2. 保守性

**問題のある構成**:
```
lua/config/lsp.lua (2000行)
├─ Lua設定
├─ Rust設定
├─ Go設定
├─ TypeScript設定
└─ ...（肥大化）
```

**改善された構成**:
```
lua/config/lsp_keymaps.lua (100行) - 共通設定のみ
after/lsp/
├─ lua_ls.lua (50行)
├─ rust_analyzer.lua (60行)
├─ gopls.lua (40行)
└─ tsserver.lua (45行)
```

言語ごとに設定が分離され、メンテナンスが容易です。

### 3. 上書き可能

プラグインのデフォルト設定を壊さずに、必要な部分だけカスタマイズできます：

```lua
-- デフォルト設定はそのまま
-- 追加したい設定のみ after/lsp/ に記述
-- 自動的にマージされる
```

### 4. テスト容易性

特定のLSP設定をテストする際：

```bash
# 一時的に無効化
mv after/lsp/lua_ls.lua after/lsp/lua_ls.lua.bak

# 再度有効化
mv after/lsp/lua_ls.lua.bak after/lsp/lua_ls.lua
```

### 5. 関心の分離（Separation of Concerns）

| ファイル | 責務 | 実行時期 |
|---------|------|--------|
| `lua/plugins/lsp.lua` | **何を**読み込むか | 起動時 |
| `lua/config/mason.lua` | **どのサーバーを**インストール/起動するか | ファイル開く時 |
| `lua/config/lsp_keymaps.lua` | **ユーザー操作**をどう処理するか | LspAttach時 |
| `after/lsp/*.lua` | **各サーバーの**詳細動作をどう調整するか | サーバー起動後 |

---

## まとめ

このNeovim設定のLSPシステムは、**4層の責務分離アーキテクチャ**により以下を実現しています：

✅ **高い拡張性** - 新しいLSPサーバーの追加が容易
✅ **優れた保守性** - 言語ごとに設定が分離
✅ **自動化** - サーバー名に基づく自動発見機構
✅ **柔軟性** - デフォルト設定を壊さずカスタマイズ可能

特に`after/lsp/`ディレクトリの活用により、**Neovimのランタイムパス自動発見メカニズム**を最大限に活用した、エレガントで拡張性の高い設計となっています。

---

## 参考資料

- ファイルパス: `lua/plugins/lsp.lua`
- ファイルパス: `lua/config/mason.lua`
- ファイルパス: `lua/config/lsp_keymaps.lua`
- ファイルパス: `after/lsp/lua_ls.lua`
- ファイルパス: `after/lsp/rust_analyzer.lua`

**生成日**: 2025-11-03
**対象**: Neovim LSP設定（Lazy.nvim + nvim-lspconfig + Mason）
