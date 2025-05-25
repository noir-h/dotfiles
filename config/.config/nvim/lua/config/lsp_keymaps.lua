vim.diagnostic.config({
    virtual_text = { spacing = 4 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local M = {}

M.setup = function()
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Prev Diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set Diagnostic List" })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
            local bufnr = args.buf
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local opts = { buffer = bufnr }

            vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Prev Diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })
            vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set Diagnostic List" })

            vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = bufnr })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = bufnr })
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation", buffer = bufnr })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References", buffer = bufnr })
            vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, { desc = "Go to Type Definition", buffer = bufnr })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

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
                and client:supports_method('textDocument/formatting') then
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
