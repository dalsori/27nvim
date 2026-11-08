vim.api.nvim_create_user_command("ToggleFormatter", function()
	require("clainev.utils.editor").toggle_formatter()
end, { desc = "Toggle formatter for current buffer" })

vim.api.nvim_create_user_command("PluginsUpdate", function()
	vim.pack.update()
end, { desc = "Review native plugin updates; :write applies, :quit cancels" })

vim.api.nvim_create_user_command("PluginsRestore", function()
	vim.pack.update(nil, { target = "lockfile" })
end, { desc = "Restore plugin revisions from nvim-pack-lock.json" })
