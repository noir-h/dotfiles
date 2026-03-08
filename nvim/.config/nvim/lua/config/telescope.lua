local M = {}

M.setup = function(opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    -- FZF拡張の読み込み
    pcall(telescope.load_extension, "fzf")
end

return M
