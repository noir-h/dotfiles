-- brew install tree-sitter-cliをしないとコンパイルがうまくいかない
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        config = function()
            require 'nvim-treesitter'.setup({})
            require 'nvim-treesitter'.install { 'rust', 'go', 'markdown', 'markdown_inline', 'html', 'latex', 'yaml', 'c', 'cpp' }
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
                callback = function(ctx)
                    -- 必要に応じて`ctx.match`に入っているファイルタイプの値に応じて挙動を制御
                    -- `pcall`でエラーを無視することでパーサーやクエリがあるか気にしなくてすむ
                    pcall(require, "nvim-treesitter")
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    }

}
