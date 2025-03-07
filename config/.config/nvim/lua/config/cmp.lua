local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- dashboardのinputでcmpが発火してしまう
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "snacks_picker_input",
--   callback = function()
--     local cmp = require("cmp")
--     cmp.setup.buffer({ enabled = false })
--   end,
-- })

