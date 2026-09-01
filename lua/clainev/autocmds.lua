-- ════════════════════════════════════════════════════════════════════
--  AUTOCOMMANDS
-- ════════════════════════════════════════════════════════════════════
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group    = augroup("YankHighlight", { clear = true }),
  callback = function() vim.highlight.on_yank { higroup = "Visual", timeout = 200 } end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  group    = augroup("RestoreCursor", { clear = true }),
  callback = function()
    local mark   = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close helper windows with q
autocmd("FileType", {
  group    = augroup("QuickClose", { clear = true }),
  pattern  = { "help", "qf", "man", "lspinfo", "checkhealth", "notify" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group   = augroup("TrailingWS", { clear = true }),
  pattern = {
    "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua", "*.py",
    "*.go", "*.rs",  "*.c",  "*.cpp", "*.php", "*.dart",
    "*.sql", "*.md", "*.sh",
  },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.winrestview(view)
  end,
})

-- Disable auto-comment on newline
autocmd("BufEnter", {
  group    = augroup("NoAutoComment", { clear = true }),
  callback = function() vim.opt_local.formatoptions:remove { "c", "r", "o" } end,
})

-- Language-specific tab widths
autocmd("FileType", {
  group    = augroup("LangTabWidth", { clear = true }),
  pattern  = { "go", "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab  = false
  end,
})

autocmd("FileType", {
  group    = augroup("PythonTabWidth", { clear = true }),
  pattern  = { "python", "php", "java" },  -- PEP 8 · PSR-12 · Java convention
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab  = true
  end,
})

autocmd("FileType", {
  group    = augroup("MarkdownSettings", { clear = true }),
  pattern  = "markdown",
  callback = function()
    vim.opt_local.wrap  = true
    vim.opt_local.spell = true
  end,
})

-- Transparencia global: quita el fondo de los floats/popups (telescope/fzf,
-- completions, notificaciones, etc.) para que queden 100% transparentes como
-- el editor. winblend se deja a 0: si no, la ventana se mezcla con el fondo
-- del terminal y vuelve a aparecer un tinte semitransparente.
local function transparent_floats()
  local groups = {
    "NormalFloat", "FloatBorder", "FloatTitle",
    "MsgArea", "MsgSeparator",
    "Pmenu", "PmenuSel", "PmenuThumb", "PmenuSbar",
    "TelescopeNormal", "TelescopeBorder",
    "TelescopePromptNormal", "TelescopePromptBorder",
    "TelescopeResultsNormal", "TelescopeResultsBorder",
    "TelescopePreviewNormal", "TelescopePreviewBorder",
    "TelescopeSelection", "TelescopeSelectionCaret",
    "TelescopePromptTitle", "TelescopeResultsTitle", "TelescopePreviewTitle",
    "NotifyBackground", "NotifyErrorBorder", "NotifyWarnBorder",
    "NotifyInfoBorder", "NotifyDebugBorder", "NotifyTraceBorder",
    "LazyNormal", "LazyBorder", "WhichKeyFloat", "WhichKeyBorder",
  }
  for _, name in ipairs(groups) do
    -- guibg=NONE fuerza transparencia real; nvim_set_hl con bg=nil no siempre limpia
    pcall(vim.api.nvim_set_hl, 0, name, { bg = "NONE", ctermbg = "NONE" })
    pcall(vim.cmd, "highlight " .. name .. " guibg=NONE ctermbg=NONE")
  end
  -- Asegura Telescope completo transparente aunque el tema lo repinte
  pcall(vim.cmd, "highlight TelescopeNormal guibg=NONE ctermbg=NONE")
  pcall(vim.cmd, "highlight TelescopeBorder guibg=NONE ctermbg=NONE")
end

-- Re-aplica la transparencia tras cada carga de colorscheme (catppuccin
-- vuelve a pintar NormalFloat y compania cuando se recarga).
autocmd("ColorScheme", {
  group    = augroup("TransparentFloats", { clear = true }),
  callback = transparent_floats,
})

-- winblend 0: nada de mezcla translucida, solo fondo quitado.
vim.opt.winblend = 0
