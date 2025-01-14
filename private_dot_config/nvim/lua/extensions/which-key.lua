opts = function()
	local wk = require("which-key")
	wk.add({
		{ "<leader>v", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
		{
			-- Nested mappings are allowed and can be added in any order
			-- Most attributes can be inherited or overridden on any level
			-- There's no limit to the depth of nesting
			mode = { "n", "v" }, -- NORMAL and VISUAL mode
			{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
			{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
		},
	})
end

wk.setup(opts())
