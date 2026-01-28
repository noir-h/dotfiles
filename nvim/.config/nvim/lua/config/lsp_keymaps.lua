vim.diagnostic.config({
    virtual_text = { spacing = 4 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.lsp.enable({
    -- nvim-lspconfig で"lua_ls"という名前で設定したプリセットが読まれる
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
    "lua_ls",
    -- 他の言語サーバーの設定
    "gopls",
})

local M = {}

M.setup = function()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
            local buf = args.buf
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            if client:supports_method("textDocument/definition") then
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
            end

            if client:supports_method("textDocument/hover") then
                vim.keymap.set("n", "gh",
                    function() vim.lsp.buf.hover({ border = "single" }) end,
                    { buffer = buf, desc = "Show hover documentation" })
            end

            if client:supports_method("textDocument/completion") then
                vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            end

            if client:supports_method("textDocument/declaration") then
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "Declaration" })
            end

            if client:supports_method("textDocument/formatting") then
                vim.keymap.set("n", "<space>lf", function()
                    vim.lsp.buf.format({ async = true })
                end, { buffer = buf, desc = "Format" })
            end

            if client:supports_method("textDocument/rename") then
                vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
            end

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "References" })
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = buf, desc = "Line Diagnostics" })
            vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
            vim.keymap.set('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>',
                { noremap = true, silent = true })
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float,
                { noremap = true, silent = true, desc = "Show line diagnostics" })
            vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, { desc = "Go to Type Definition", buffer = buf })


            if not client:supports_method('textDocument/willSaveWaitUntil')
                and client:supports_method('textDocument/formatting')
                and client.name ~= "ts_ls" then -- tsserver の場合はスキップ
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
                    buffer = buf,
                    callback = function()
                        vim.lsp.buf.format({ buffer = buf, id = client.id, timeout_ms = 1000 })
                    end,
                })
            end

            if client:supports_method("textDocument/inlineCompletion") then
                vim.lsp.inline_completion.enable(true, { buffer = buf })
                vim.keymap.set("i", "<Tab>", function()
                    if not vim.lsp.inline_completion.get() then
                        return "<Tab>"
                    end
                    -- close the completion popup if it's open
                    if vim.fn.pumvisible() == 1 then
                        return "<C-e>"
                    end
                end, {
                    expr = true,
                    buffer = buf,
                    desc = "Accept the current inline completion",
                })
            end
        end,
    })
end

return M
