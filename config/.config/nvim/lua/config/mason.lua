require 'mason'.setup()

-- (同じ) masonを介してlanguage serverを自動インストールする
local ensure_installed = { 'ts_ls', 'lua_ls', 'gopls' }
require 'mason-lspconfig'.setup {
    automatic_installation = true,
    ensure_installed = ensure_installed, -- 自動でインストールしたいlanguage server
    -- automatic_enable = false           -- Neovim 0.11+ ではこれが有効で自動起動される
}
