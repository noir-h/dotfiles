local M = {}

M.opts = {
  diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  },

  inlay_hints = {
    enabled = true,
    exclude = { "vue" },
  },

  format = {
    formatting_options = nil,
    timeout_ms = nil,
  },

  capabilities = vim.lsp.protocol.make_client_capabilities(),
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),

  servers = {
     lua_ls = {
       settings = {
         Lua = {
           workspace = { checkThirdParty = false },
           completion = { callSnippet = "Replace" },
           hint = { enable = true, paramType = true },
         },
       },
     },
    pyright = {},
    rust_analyzer = {
      setttins = {
        ["rust-analyzer"] = {
          hint = { enable = true, paramType = true },
        },
      },
    },
    gopls = {},
  },
}

M.setup = function(opts)
  -- Diagnostics 設定
  vim.diagnostic.config(opts.diagnostics)

   -- LSP サーバーのセットアップ
   local lspconfig = require("lspconfig")
   for server, server_opts in pairs(opts.servers) do
     lspconfig[server].setup(server_opts)
   end

  -- LSP のキーマップを設定
  require("config.lsp_keymaps").setup()
end

return M
