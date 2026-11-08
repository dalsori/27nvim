local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without updating the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit<CR>")
keymap.set("n", "<tab>", ":tabnext<CR>", opts)
keymap.set("n", "<s-tab>", ":tabprev<CR>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Toggle inlay hints
keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

keymap.set("n", "ZR", "<cmd>restart<CR>", { desc = "Restart Neovim (save first)" })
keymap.set("n", "<C-s>", "<cmd>write<CR>", { desc = "Save" })
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Yank current file path
keymap.set("n", "<leader>yf", function()
	require("clainev.utils.editor").yank_relative_path_with_line()
end, { desc = "Yank relative path with line number" })

keymap.set("n", "<leader>yp", function()
	require("clainev.utils.editor").yank_absolute_path_with_line()
end, { desc = "Yank absolute path with line number" })

keymap.set("v", "<leader>cc", ":<C-u>lua require('clainev.utils.editor').copy_as_codeblock()<CR>")

keymap.set("n", "<leader>j", function()
	require("clainev.utils.editor").open_package_json()
end, { desc = "Open package.json in floating window" })

keymap.set("n", "<leader>bd", function()
	require("clainev.utils.editor").delete_hidden_buffers()
end, { desc = "Delete hidden buffers" })
