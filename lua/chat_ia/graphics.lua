local M = {}
local window_config = require("chat_ia.config").options.window_defaults
local gemini_functions = require("chat_ia.gemini")

local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local popup = Popup(window_config)

local last_line_row = 1

-- Funcion para escribir dentro de la ventana :
function Write_response_window(response, buffer)
	local antique_lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

	local new_text = vim.split("\n#GEMINI \n" .. response .. "\n#Vos \n", "\n")

	for _, line in ipairs(new_text) do
		table.insert(antique_lines, line)
	end
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, antique_lines)
	last_line_row = #antique_lines
end

-- Funcion para cuando se crea una nueva ventana :
function M.createWindow()
	popup:mount()
	local buffer = popup.bufnr

	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.split("Vos \n", "\n"))
	vim.api.nvim_win_set_cursor(popup.winid, { 2, 0 })

	vim.api.nvim_buf_set_option(buffer, "filetype", "markdown")

	vim.keymap.set("n", "q", function()
		popup:unmount()
	end, { buffer = popup.bufnr, nowait = true, noremap = true, silent = true })

	vim.keymap.set("n", "<CR>", function()
		local user_input = vim.api.nvim_get_current_line()
		local response = gemini_functions.queryGemini(user_input)
		Write_response_window(response, buffer)
		vim.api.nvim_win_set_cursor(popup.winid, { last_line_row, 0 })
	end, { buffer = buffer, nowait = true, noremap = true, silent = true })
end

return M
