local M = {}

M.setup = function()
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Prev Diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set Diagnostic List" })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("i", "<C-n>", vim.lsp.completion.get, { desc = "completion get", buffer = ev.buf })
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = ev.buf })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = ev.buf })
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation", buffer = ev.buf })

            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References", buffer = ev.buf })
            vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, { desc = "Go to Type Definition", buffer = ev.buf })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

            -- 📌 コードアクション リファクタリング フォーマット
            vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, { desc = "Code Action", buffer = ev.buf })
            vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = ev.buf })
            vim.keymap.set("n", "<space>lf", function()
                vim.lsp.buf.format({ async = true })
            end, { desc = "Format Document", buffer = ev.buf })

            -- 使うかどうかわからない
            -- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
            -- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        end,
    })
end

return M
