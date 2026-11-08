if vim.fn.has("nvim-0.12") == 0 then
	error("27nvim requires Neovim 0.12 or newer")
end

if vim.loader then
	vim.loader.enable()
end

require("clainev.config.platform")
_G.Clainev = require("clainev.utils")
require("clainev.config.options")
require("clainev.config.keymaps")
require("clainev.config.autocmds")
require("clainev.config.commands")
require("clainev.config.workarounds")
require("clainev.plugins")
