-- No plugins or network required: nvim --headless -l tests/editor.lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local editor = require("clainev.utils.editor")
local tmp = vim.fn.tempname() .. " context with spaces"
vim.fn.mkdir(tmp .. "/.git", "p")
vim.fn.writefile({ "{}" }, tmp .. "/package.json")
local old_cwd = vim.fn.getcwd()
local old_setreg, old_notify = vim.fn.setreg, vim.notify
local clipboard
vim.fn.setreg = function(reg, value)
	assert(reg == "+")
	clipboard = value
end
vim.notify = function() end

local ok, err = xpcall(function()
	vim.cmd.cd(vim.fn.fnameescape(tmp))
	vim.cmd.enew()
	vim.api.nvim_buf_set_name(0, tmp .. "/sample file.ts")
	vim.bo.filetype = "typescript"
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "const code = `", "```", "`;" })
	vim.api.nvim_win_set_cursor(0, { 2, 0 })
	editor.yank_relative_path_with_line()
	assert(clipboard == "sample file.ts#L2", clipboard)
	editor.yank_absolute_path_with_line()
	assert(clipboard == vim.fs.normalize(tmp .. "/sample file.ts") .. "#L2", clipboard)
	vim.api.nvim_buf_set_mark(0, "<", 1, 0, {})
	vim.api.nvim_buf_set_mark(0, ">", 3, 0, {})
	editor.copy_as_codeblock()
	assert(
		clipboard == '````ts filename="sample file.ts" line=1\nconst code = `\n```\n`;\n````',
		clipboard
	)
	local unsaved = vim.api.nvim_get_current_buf()
	vim.cmd("enew!")
	local clean = vim.api.nvim_create_buf(true, false)
	editor.delete_hidden_buffers()
	assert(vim.api.nvim_buf_is_valid(unsaved), "Unsaved hidden buffer was deleted")
	assert(not vim.api.nvim_buf_is_valid(clean), "Clean hidden buffer was not deleted")
	clipboard = nil
	editor.yank_relative_path_with_line()
	assert(clipboard == nil, "Unnamed buffer copied a fake path")
	editor.open_package_json()
	assert(
		vim.fs.basename(vim.api.nvim_buf_get_name(0)) == "package.json",
		"Root lookup from empty buffer failed"
	)
	editor.toggle_formatter()
	assert(vim.b.disable_autoformat == true)
	editor.toggle_formatter()
	assert(vim.b.disable_autoformat == false)
end, debug.traceback)

vim.fn.setreg, vim.notify = old_setreg, old_notify
vim.cmd.cd(vim.fn.fnameescape(old_cwd))
-- Only the unique temporary directory created above is removed.
vim.fn.delete(tmp, "rf")
if not ok then
	io.stderr:write(tostring(err) .. "\n")
	os.exit(1)
end
print("OK: paths, Markdown fences, project root, unsaved buffers and formatter toggle")
