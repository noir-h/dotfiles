local function pick_dir(default)
    local dir = vim.fn.input("Directory: ", default or vim.fn.expand("%:p:h"), "dir")
    if dir == nil or dir == "" then
        return nil
    end
    return dir
end

local function find_files_in_dir()
    local dir = pick_dir()
    if not dir then
        return
    end
    require("telescope.builtin").find_files({ cwd = dir })
end

local function live_grep_in_dir()
    local dir = pick_dir()
    if not dir then
        return
    end
    require("telescope.builtin").live_grep({ cwd = dir })
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        cmd = "Telescope",
        keys = {
            -- ファイル検索
            { "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",             desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",               desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",             desc = "Help Tags" },

            -- コード参照検索（LSP）
            { "<leader>fr", "<cmd>Telescope lsp_references<cr>",        desc = "Find References" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
            { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

            -- 診断情報
            { "<leader>e",  "<cmd>Telescope diagnostics<cr>",           desc = "Diagnostics" },

            -- カスタム検索コマンド
            {
                "<leader>f/",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find()
                end,
                desc = "Search in Buffer",
            },

            -- ディレクトリ指定検索
            {
                "<leader>fd",
                find_files_in_dir,
                desc = "Find Files in Directory",
            },
            {
                "<leader>fD",
                live_grep_in_dir,
                desc = "Live Grep in Directory",
            },
        },
        opts = {
            defaults = {
                -- find_files, rg共通
                file_ignore_patterns = {
                    "%.git/",
                    "node_modules/",
                    "%.DS_Store",
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    -- find_command = {
                    --     "rg",
                    --     "--files",
                    --     -- "--glob=!**/.git/*",
                    --     -- "--glob=!**/node_modules/*",
                    -- },
                },
                -- live_grep = {
                --     additional_args = function()
                --         return {
                --             "--hidden",
                --             "--glob=!**/.git/*",
                --             "--glob=!**/node_modules/*",
                --         }
                --     end,
                -- },
            },
        },
        config = function(_, opts)
            require("config.telescope").setup(opts)
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
