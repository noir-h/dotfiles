-- 文字列がパスかどうか判定します
local function isPath(inputString)
    return string.find(inputString, "[/\\]")
end

-- 文字列をスペースで分割します
local function splitString(inputString)
    local splittedStrings = {}
    for word in string.gmatch(inputString, "%S+") do
        table.insert(splittedStrings, word)
    end
    return splittedStrings
end

-- 文字列からパスを取り除きます
local function removePathFromString(inputString)
    local splittedStrings = splitString(inputString)

    local processedStrings = {}
    for _, word in ipairs(splittedStrings) do
        if not isPath(word) then
            table.insert(processedStrings, word)
        end
    end

    local processedString = ""
    for i, word in ipairs(processedStrings) do
        if i == #processedStrings then
            processedString = processedString .. word
        else
            processedString = processedString .. word .. " "
        end
    end

    return processedString
end


return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('config.lualine')
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            progress = {
                display = {
                    format_message = function(msg)
                        local message = ""
                        if not msg.message then
                            message = msg.done and "Completed" or "In progress..."
                        else
                            message = removePathFromString(msg.message)
                        end
                        if msg.percentage ~= nil then
                            message = string.format("%s (%.0f%%)", message, msg.percentage)
                        end
                        return message
                    end,
                }
            }
        },
    },
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("barbar").setup({
                animation = true,                  -- アニメーションを有効化
                auto_hide = false,                 -- 1つのバッファだけの時も表示
                tabpages = true,                   -- タブページごとにバッファを管理
                clickable = true,                  -- タブをクリックで切り替え
                icons = {
                    buffer_index = true,           -- バッファ番号を表示
                    filetype = { enabled = true }, -- ファイルタイプのアイコンを表示
                },
            })
        end,
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }

}
