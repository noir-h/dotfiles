return {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
            completion = {
                autoimport = {
                    enable = true,
                },
                -- プライベートアイテムを補完候補に含めない
                privateEditable = {
                    enable = false,
                },
                -- 補完候補の最大数を制限
                limit = 50,
            },
        },
    },
}
