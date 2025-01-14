require("Comment").setup()
vim.keymap.set("n", "<c-c>", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "1行コメントアウト" })
