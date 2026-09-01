-- ════════════════════════════════════════════════════════════════════
--  KEYMAPS
-- ════════════════════════════════════════════════════════════════════
local map = vim.keymap.set

-- ── General ───────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("i", "jk", "<ESC>", { desc = "Exit insert" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })

-- ── Move lines ────────────────────────────────────────────────────
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Window navigation ─────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Focus left" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus down" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus up" })

-- Resize splits
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Resize up" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Resize down" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })

-- ── Buffers ───────────────────────────────────────────────────────
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>X", "<cmd>bdelete!<CR>", { desc = "Force close buffer" })

-- ── Explorer ──────────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle explorer" })
map("n", "<leader>ef", "<cmd>Neotree reveal<CR>", { desc = "Reveal file" })

-- ── Git ───────────────────────────────────────────────────────────
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

-- ── Trouble ───────────────────────────────────────────────────────
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace diagnostics" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<CR>", { desc = "Symbols" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix" })

-- ── Terminal ──────────────────────────────────────────────────────
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal term" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical term" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Float term" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })

-- ── Numbers ───────────────────────────────────────────────────────
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- ── Editing ───────────────────────────────────────────────────────
map("n", "dw", 'vb"_d', { desc = "Delete word backwards" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
map("n", "zz", ":q!<CR>", { desc = "Quit without saving" })
map("n", "zw", ":wq!<CR>", { desc = "Save and quit" })

-- ── Splits ────────────────────────────────────────────────────────
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal split sizes" })
map("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })

-- ── Tabs ──────────────────────────────────────────────────────────
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR><cmd>bdelete<CR>", { desc = "Close tab" })
map("n", "L", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "H", "<cmd>tabprev<CR>", { desc = "Prev tab" })

-- ── Misc ──────────────────────────────────────────────────────────
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Undo tree" })
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown preview" })

-- ── Database (dadbod) ─────────────────────────────────────────────
map("n", "<leader>Du", "<cmd>DBUIToggle<CR>", { desc = "Database UI" })
map("n", "<leader>Da", "<cmd>DBUIAddConnection<CR>", { desc = "Add DB connection" })

-- ── Flutter ───────────────────────────────────────────────────────
map("n", "<leader>Fr", "<cmd>FlutterRun<CR>", { desc = "Flutter run" })
map("n", "<leader>Fd", "<cmd>FlutterDevices<CR>", { desc = "Flutter devices" })
map("n", "<leader>Fq", "<cmd>FlutterQuit<CR>", { desc = "Flutter quit" })
map("n", "<leader>FR", "<cmd>FlutterReload<CR>", { desc = "Flutter hot reload" })
map("n", "<leader>FL", "<cmd>FlutterLogs<CR>", { desc = "Flutter logs" })

-- ── Theme (Monokai) ─────────────────────────────────────────────
-- <leader>tt = toggle Dark/Light, <leader>td = dark, <leader>tl = light
map("n", "<leader>tt", function() if _G.toggle_monokai then _G.toggle_monokai() else vim.cmd("colorscheme monokai-pro") end end, { desc = "Toggle Monokai Dark/Light" })
map("n", "<leader>td", "<cmd>MonokaiDark<CR>", { desc = "Monokai Dark" })
map("n", "<leader>tl", "<cmd>MonokaiLight<CR>", { desc = "Monokai Light" })

-- ── AI (Avante) ───────────────────────────────────────────────────
map("n", "<leader>aa", "<cmd>AvanteToggle<CR>", { desc = "AI Chat Sidebar" })
map("n", "<leader>ac", "<cmd>AvanteAsk<CR>", { desc = "AI Ask" })
map("v", "<leader>ac", "<cmd>AvanteAsk<CR>", { desc = "AI Ask (selection)" })
map("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "AI Edit" })
map("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "AI Edit (selection)" })
map("n", "<leader>ah", "<cmd>AvanteHistory<CR>", { desc = "AI History" })
