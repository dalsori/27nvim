-- Run after normal init: NVIM_TEST=1 nvim --headless -c "lua dofile('tests/health.lua')"
local function run()
	assert(vim.fn.has("nvim-0.12") == 1, "Neovim 0.12 required")
	assert(vim.v.errmsg == "", vim.v.errmsg)
	assert(vim.g.mapleader == " ")
	assert(vim.g.colors_name == "solarized-osaka")
	assert(vim.o.pumblend == 0 and vim.o.winblend == 0, "UI must be opaque")
	assert(vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg, "Normal background missing")
	assert(
		vim.api.nvim_get_hl(0, { name = "TabLineFill", link = false }).bg,
		"Tabline background missing"
	)
	assert(vim.fn.isdirectory(vim.o.undodir) == 1, "Undo directory missing")
	assert(not package.loaded.lazy, "Legacy plugin manager still loaded")
	local count = 0
	for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
		if plugin.active then
			count = count + 1
			assert(vim.fn.isdirectory(plugin.path) == 1, plugin.spec.name .. " missing")
		end
	end
	assert(count >= 24, "Incomplete native plugin installation")
	for _, module in ipairs({
		"snacks",
		"oil",
		"blink.cmp",
		"codediff",
		"mini.diff",
		"conform",
		"copilot",
	}) do
		assert(package.loaded[module], module .. " not configured")
	end
	for _, key in ipairs({
		";f",
		";r",
		";g",
		"sf",
		"ZR",
		"<leader>gd",
		"<leader>dv",
		"<leader>dh",
		"<leader>yf",
		"<leader>yp",
	}) do
		assert(vim.fn.maparg(key, "n") ~= "", "Missing keymap " .. key)
	end
	assert(vim.fn.maparg("<leader>cc", "v") ~= "", "Selection context mapping missing")
	for _, command in ipairs({
		"CodeDiff",
		"Oil",
		"Copilot",
		"ToggleFormatter",
		"PluginsUpdate",
		"PluginsRestore",
	}) do
		assert(vim.fn.exists(":" .. command) == 2, command .. " missing")
	end
	assert(vim.lsp.config.vtsls.settings.vtsls.autoUseWorkspaceTsdk, "after/lsp override missing")
	print(
		("OK: native startup, %d plugins, commands, keymaps, LSP configuration and opaque UI"):format(
			count
		)
	)
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
	io.stderr:write(tostring(err) .. "\n")
	vim.cmd("cquit 1")
end
