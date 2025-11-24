vim.diagnostic.config({
    virtual_text = { spacing = 4 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local M = {}

M.setup = function()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
            local bufnr = args.buf
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = bufnr })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = bufnr })
            vim.keymap.set('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>',
                { noremap = true, silent = true })
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float,
                { noremap = true, silent = true, desc = "Show line diagnostics" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References", buffer = bufnr })
            vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, { desc = "Go to Type Definition", buffer = bufnr })

            vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
            vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = bufnr })
            vim.keymap.set("n", "<space>lf", function()
                vim.lsp.buf.format({ async = true })
            end, { desc = "Format Document", buffer = bufnr })

            if client:supports_method('textDocument/completion') then
                local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                client.server_capabilities.completionProvider.triggerCharacters = chars
                vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
            end

            if not client:supports_method('textDocument/willSaveWaitUntil')
                and client:supports_method('textDocument/formatting')
                and client.name ~= "ts_ls" then -- tsserver の場合はスキップ
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 3000 })
                    end,
                })
            end
        end,
    })
end

return M
