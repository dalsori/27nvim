-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Agent edits reload only when this will not lose local edits.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = augroup,
	callback = function()
		if vim.fn.getcmdwintype() == "" and vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "python", "php", "java" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup,
	pattern = "*",
	command = "set nopaste",
})

-- Highlight the current line on only the active buffer
local cursorline_group = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
	group = cursorline_group,
	pattern = "*",
	command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = cursorline_group,
	pattern = "*",
	command = "setlocal nocursorline",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Custom filetypes
vim.filetype.add({
	extension = {
		mjml = "html",
	},
})
