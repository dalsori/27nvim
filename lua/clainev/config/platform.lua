-- Keep platform changes inside Neovim; do not change the user's system shell.
vim.g.is_windows = vim.fn.has("win32") == 1
vim.g.have_nerd_font = true
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local sep = vim.g.is_windows and ";" or ":"
vim.env.PATH = mason_bin .. sep .. (vim.env.PATH or "")

if vim.g.is_windows then
	if vim.fn.executable("cl") == 0 and vim.fn.executable("gcc") == 1 then
		vim.env.CC = vim.env.CC or "gcc"
		vim.env.CXX = vim.env.CXX or "g++"
	end
	local java = vim.fn.expand("~/scoop/apps/temurin-lts-jdk/current")
	if vim.uv.fs_stat(java .. "/bin/java.exe") then
		vim.env.JAVA_HOME = java
	end
end
