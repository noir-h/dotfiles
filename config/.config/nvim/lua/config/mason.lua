require 'mason'.setup()

-- (同じ) masonを介してlanguage serverを自動インストールする
local ensure_installed = { 'ts_ls', 'lua_ls', 'gopls' }
require 'mason-lspconfig'.setup {
    automatic_installation = true,
    ensure_installed = ensure_installed, -- 自動でインストールしたいlanguage server
    -- automatic_enable = false           -- Neovim 0.11+ ではこれが有効で自動起動される
}

-- (NEW) language serverの設定をする
-- vim.lsp.config('lua_ls', {
--   -- nvim-lspconfig が設定したコンフィグにsettingsを追加する
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' }
--       },
--     }
--   },
-- })
-- vim.lsp.enable(ensure_installed)

-- lspconfig の設定値を活かしつつ settings を追加する
-- local lua_ls_config = vim.lsp.extended_config("lua_ls", {
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { "vim" },
--       },
--     },
--   },
-- })
-- -- 設定を登録（起動は automatic_enable がやってくれる）
-- vim.lsp.config("lua_ls", lua_ls_config)
