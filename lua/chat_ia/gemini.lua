local M = {}

local api_key = os.getenv("GEMINI_API_KEY")

function M.queryGemini(prompt)
	local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key="
		.. api_key

	local body = vim.fn.json_encode({
		contents = {
			{
				parts = {
					{ text = prompt },
				},
			},
		},
	})

	local cmd = {
		"curl",
		"-s",
		"-X",
		"POST",
		url,
		"-H",
		"Content-Type: application/json",
		"-d",
		body,
	}

	local result = vim.fn.system(cmd)
	local ok, decoded = pcall(vim.fn.json_decode, result)
	if not ok or not decoded then
		vim.notify("error")
		return
	end

	local text = decoded.candidates and decoded.candidates[1] and decoded.candidates[1].content.parts[1].text
		or "Sin respuesta"
	return text
end

return M
