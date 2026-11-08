local M = {}
function M.open()
	if vim.fn.executable("lazygit") == 0 then
		vim.notify("Install lazygit and add it to PATH", vim.log.levels.WARN)
		return
	end
	require("snacks").lazygit()
end
return M
