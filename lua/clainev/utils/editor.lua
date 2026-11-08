---@class utils.editor
local M = {}

-- Root detection markers
local root_patterns =
	{ ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

--- Get the current working directory
---@return string
local function get_cwd()
	return vim.uv.cwd() or vim.fn.getcwd()
end

--- Normalize a path (resolve symlinks, ensure consistent format)
---@param path string
---@return string
local function normalize(path)
	if path:sub(1, 1) == "~" then
		path = vim.fn.expand(path)
	end
	path = vim.uv.fs_realpath(path) or path
	return vim.fs.normalize(path):gsub("/$", "")
end

--- Find the project root directory
---@return string
local function get_root()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		path = get_cwd()
	else
		path = vim.fs.dirname(path)
	end

	local root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
	if root then
		return normalize(vim.fs.dirname(root))
	end

	return normalize(get_cwd())
end

--- Check if a file exists
---@param filepath string
---@return boolean
local function file_exists(filepath)
	local stat = vim.uv.fs_stat(filepath)
	return stat ~= nil and stat.type == "file"
end

--- Open package.json in a floating window with 80% width and height
function M.open_package_json()
	local root = get_root()
	local package_json = root .. "/package.json"

	if not file_exists(package_json) then
		vim.notify("package.json not found in project root: " .. root, vim.log.levels.WARN)
		return
	end

	-- Calculate 80% dimensions
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	-- Center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create buffer and load file
	local buf = vim.fn.bufadd(package_json)
	vim.fn.bufload(buf)

	-- Create floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = " package.json ",
		title_pos = "center",
	})

	-- Set window options
	vim.wo[win].winblend = 0
	vim.wo[win].cursorline = true

	-- Close on q or <Esc>
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true })
end

--- Copy selected lines as a Markdown codeblock with filename and line number
function M.copy_as_codeblock()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
	if filepath == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end

	local root = get_root()
	local relative = vim.fs.relpath(root, filepath) or filepath
	local ft_to_lang = {
		typescriptreact = "tsx",
		javascriptreact = "jsx",
		typescript = "ts",
		javascript = "js",
	}
	local lang = ft_to_lang[vim.bo.filetype] or vim.bo.filetype

	local result = {}
	local fence = "```"
	for _, line in ipairs(lines) do
		for ticks in line:gmatch("`+") do
			if #ticks >= #fence then
				fence = string.rep("`", #ticks + 1)
			end
		end
	end
	table.insert(
		result,
		fence .. lang .. " filename=" .. vim.json.encode(relative) .. " line=" .. start_line
	)
	for _, line in ipairs(lines) do
		table.insert(result, line)
	end
	table.insert(result, fence)

	local text = table.concat(result, "\n")
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. #lines .. " lines as codeblock", vim.log.levels.INFO)
end

--- Delete all listed buffers that are not shown in any window
function M.delete_hidden_buffers()
	local visible_bufs = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible_bufs[vim.api.nvim_win_get_buf(win)] = true
	end

	local deleted = 0
	local skipped = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and not visible_bufs[buf] then
			if vim.bo[buf].modified then
				skipped = skipped + 1
			else
				vim.api.nvim_buf_delete(buf, {})
				deleted = deleted + 1
			end
		end
	end

	local msg = "Deleted " .. deleted .. " hidden buffer" .. (deleted == 1 and "" or "s")
	if skipped > 0 then
		msg = msg .. " (" .. skipped .. " skipped, unsaved changes)"
	end
	vim.notify(msg, vim.log.levels.INFO)
end

--- Enable or disable the current buffer's formatter
function M.toggle_formatter()
	local bufnr = vim.api.nvim_get_current_buf()
	local disabled = vim.b[bufnr].disable_autoformat

	if disabled then
		vim.b[bufnr].disable_autoformat = false
		vim.notify("Formatter enabled for this buffer", vim.log.levels.INFO)
	else
		vim.b[bufnr].disable_autoformat = true
		vim.notify("Formatter disabled for this buffer", vim.log.levels.WARN)
	end
end

local function yank_path(absolute)
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" or vim.bo.buftype ~= "" then
		vim.notify("Open a file before copying its path", vim.log.levels.WARN)
		return
	end
	local file = vim.fs.normalize(name)
	local path = (absolute and file or (vim.fs.relpath(get_cwd(), file) or file))
		.. "#L"
		.. vim.fn.line(".")
	vim.fn.setreg("+", path)
	vim.notify("Yanked: " .. path, vim.log.levels.INFO)
end

function M.yank_relative_path_with_line()
	yank_path(false)
end

function M.yank_absolute_path_with_line()
	yank_path(true)
end

return M
