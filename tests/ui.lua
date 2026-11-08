-- Run in an attached terminal: NVIM_TEST=1 nvim -c "lua dofile('tests/ui.lua')"
-- Requires installed parsers and CodeDiff's native library.
vim.defer_fn(function()
	local steps = {}
	local function step(name, callback)
		callback()
		steps[#steps + 1] = "OK: " .. name
	end
	local ok, err = xpcall(function()
		step("UI2 and floating command line", function()
			assert(#vim.api.nvim_list_uis() > 0, "Run in a terminal, without --headless")
			assert(package.loaded["tiny-cmdline"])
			assert(package.loaded["vim._core.ui2"])
			assert(vim.v.errmsg == "", vim.v.errmsg)
		end)
		step("File picker", function()
			local picker = Snacks.picker.files({ cwd = vim.fn.getcwd() })
			assert(
				vim.wait(10000, function()
					return #picker:items() > 0
				end),
				"Picker returned no files"
			)
			picker:close()
		end)
		step("Oil float", function()
			local origin = vim.api.nvim_get_current_win()
			require("oil").open_float()
			assert(vim.wait(5000, function()
				return vim.bo.filetype == "oil"
			end))
			local oil_win = vim.api.nvim_get_current_win()
			require("oil").close()
			assert(vim.wait(5000, function()
				return not vim.api.nvim_win_is_valid(oil_win)
			end))
			vim.api.nvim_set_current_win(origin)
		end)
		step("CodeDiff native library and review view", function()
			local diff = require("codediff.core.diff").compute_diff({ "before" }, { "after" })
			assert(diff and #diff.changes > 0)
			vim.cmd("CodeDiff")
			assert(vim.wait(10000, function()
				return #vim.api.nvim_list_tabpages() > 1
			end))
			vim.wait(1000)
			assert(vim.v.errmsg == "", vim.v.errmsg)
		end)
	end, debug.traceback)
	if not ok then
		steps[#steps + 1] = "FAIL: " .. tostring(err)
	end
	vim.fn.writefile(steps, vim.fn.stdpath("cache") .. "/27nvim-ui-test.log")
	vim.cmd(ok and "qa!" or "cquit 1")
end, 1000)
