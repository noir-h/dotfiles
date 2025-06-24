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

            -- 完全一致検索
            {
                "<leader>fW",
                function()
                    require("telescope.builtin").grep_string({
                        search = vim.fn.expand("<cword>"),
                        use_regex = false,
                    })
                end,
                desc = "Find Word (exact match)"
            },

            -- 入力ワード完全一致検索
            {
                "<leader>fE",
                function()
                    local word = vim.fn.input("Search exact word: ")
                    if word ~= "" then
                        require("telescope.builtin").grep_string({
                            search = word,
                            use_regex = false,
                            word_match = "-w", -- 単語境界マッチ
                        })
                    end
                end,
                desc = "Find Exact Word Input"
            },

            -- ディレクトリ指定完全一致検索
            {
                "<leader>fP",
                function()
                    local dir = vim.fn.input("Directory: ", vim.fn.expand("%:p:h"), "dir")
                    if dir ~= "" then
                        local word = vim.fn.input("Search exact word in " .. dir .. ": ")
                        if word ~= "" then
                            require("telescope.builtin").grep_string({
                                search = word,
                                use_regex = false,
                                word_match = "-w",
                                cwd = dir,
                            })
                        end
                    end
                end,
                desc = "Find Exact Word in Directory"
            },

            -- カスタム検索コマンド
            {
                "<leader>f/",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find()
                end,
                desc = "Search in Buffer"
            },

            -- ディレクトリ指定検索
            {
                "<leader>fd",
                function()
                    require("telescope.builtin").find_files({
                        cwd = vim.fn.input("Directory: ", vim.fn.expand("%:p:h"), "dir")
                    })
                end,
                desc = "Find Files in Directory"
            },

            {
                "<leader>fD",
                function()
                    require("telescope.builtin").live_grep({
                        cwd = vim.fn.input("Directory: ", vim.fn.expand("%:p:h"), "dir")
                    })
                end,
                desc = "Live Grep in Directory"
            },
        },
        opts = {
            --     defaults = {
            --         prompt_prefix = " ",
            --         selection_caret = " ",
            --         path_display = { "truncate" },
            --         file_ignore_patterns = {
            --             "%.git/",
            --             "node_modules/",
            --             "%.DS_Store",
            --         },
            --         layout_config = {
            --             horizontal = {
            --                 preview_width = 0.6,
            --                 prompt_position = "top",
            --                 results_width = 0.8,
            --             },
            --             vertical = {
            --                 mirror = false,
            --             },
            --             width = 0.87,
            --             height = 0.80,
            --             preview_cutoff = 120,
            --         },
            --         mappings = {
            --             i = {
            --                 ["<C-u>"] = false,
            --                 ["<C-d>"] = false,
            --                 ["<C-j>"] = "move_selection_next",
            --                 ["<C-k>"] = "move_selection_previous",
            --             },
            --         },
            --     },
            --     pickers = {
            --         find_files = {
            --             theme = "dropdown",
            --             previewer = false,
            --             layout_config = {
            --                 width = 0.8,
            --                 height = 0.9,
            --             },
            --         },
            --         buffers = {
            --             theme = "dropdown",
            --             previewer = false,
            --             layout_config = {
            --                 width = 0.8,
            --                 height = 0.9,
            --             },
            --         },
            --         grep_string = {
            --             additional_args = function()
            --                 return { "--fixed-strings" } -- 完全一致検索のため
            --             end,
            --         },
            --         live_grep = {
            --             additional_args = function()
            --                 return { "--hidden" }
            --             end,
            --         },
            --     },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            -- FZF拡張の読み込み
            pcall(telescope.load_extension, "fzf")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
