local window_functions = require("chat_ia.graphics")

local M = {}

local keymaps = {
	toogle_win = "<leader>m",
}

function M.setup()
	vim.keymap.set("n", keymaps.toogle_win, function()
		window_functions.createWindow()
	end, { desc = "Toogle window" })
end

return M
