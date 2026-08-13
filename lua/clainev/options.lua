-- ════════════════════════════════════════════════════════════════════
--  OPTIONS
-- ════════════════════════════════════════════════════════════════════

-- Detect OS (must be before lazy)
vim.g.is_windows    = vim.fn.has "win32" == 1

-- Exponer mason/bin en el PATH: nvim-dap busca codelldb, js-debug-adapter,
-- php-debug-adapter y dlv por nombre (igual que nvim-dap-go), y esos
-- binarios solo existen dentro del paquete de Mason. Sin esto, F5 en
-- Rust/C/C++/JS/TS/PHP/Go falla con "command not found".
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
if vim.uv.fs_stat(mason_bin) and not vim.env.PATH:find(mason_bin, 1, true) then
  local sep = vim.g.is_windows and ";" or ":"
  vim.env.PATH = mason_bin .. sep .. vim.env.PATH
end

-- Windows + MinGW: tree-sitter CLI compila con cl.exe por defecto;
-- sin MSVC hay que apuntarlo a gcc/g++ (parsers de treesitter y kulala)
if vim.g.is_windows and vim.fn.executable "cl" == 0 and vim.fn.executable "gcc" == 1 then
  vim.env.CC  = vim.env.CC or "gcc"
  vim.env.CXX = vim.env.CXX or "g++"
end

-- jdtls necesita JDK 21+: usar el Temurin de scoop (solo dentro de nvim,
-- sin cambiar el Java del sistema)
if vim.g.is_windows then
  local temurin = vim.fn.expand "~/scoop/apps/temurin-lts-jdk/current"
  if vim.uv.fs_stat(temurin .. "/bin/java.exe") then
    vim.env.JAVA_HOME = temurin
  end
end

-- Leader (must be before lazy)
vim.g.mapleader     = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true   -- hybrid line numbers
opt.cursorline     = true
opt.showmode       = false  -- statusline handles this
opt.signcolumn     = "yes"
opt.termguicolors  = true
opt.conceallevel   = 0
opt.pumheight      = 10
opt.list           = true
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }

-- Behaviour
opt.mouse          = ""     -- 100% keyboard
opt.clipboard      = "unnamedplus"
opt.breakindent    = true
opt.undofile       = true
opt.updatetime     = 200
opt.timeoutlen     = 400
opt.inccommand     = "split" -- live preview of :s substitutions

-- Search
opt.ignorecase     = true
opt.smartcase      = true

-- Splits
opt.splitright     = true
opt.splitbelow     = true

-- Scroll
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false

-- Indentation (defaults; overridden per-filetype in autocmds)
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = true

-- Folding via treesitter
opt.foldmethod     = "expr"
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel      = 99

-- Sessions (persistence.nvim)
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
