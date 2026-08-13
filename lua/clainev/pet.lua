-- ════════════════════════════════════════════════════════════════════
--  PET — mascota que saluda al entrar al editor
--  Dibuja un gato ASCII en una ventana flotante (esquina inferior
--  derecha) con un globo de texto que saluda por el nombre de usuario.
--  Sin dependencias externas: solo API nativa, sirve en cualquier
--  terminal (kitty, alacritty, tmux, ...).
-- ════════════════════════════════════════════════════════════════════

local M = {}

local ART = {
  "   /\\_/\\   ",
  "  ( o.o )  ",
  "   > ^ <   ",
}

local ART_W = 9

local MESSAGES = {
  "¡Hola, %s!",
  "¡Bienvenido, %s!",
  "Qué gusto verte, %s!",
  "¿Qué toca hoy, %s?",
}

local COLORS = {
  pet  = "#f9e2af", -- catppuccin mocha yellow (el gato)
  text = "#a6e3a1", -- catppuccin mocha green  (el mensaje)
}

local function username()
  local user = vim.env.USER or vim.env.LOGNAME
  if user and user ~= "" then
    return user
  end
  return "amigo"
end

local function center(line, width)
  local w = vim.api.nvim_strwidth(line)
  return string.rep(" ", math.floor((width - w) / 2)) .. line
end

function M.greet()
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local user = username()
  local msg  = MESSAGES[math.random(#MESSAGES)]:format(user)
  local tw   = vim.api.nvim_strwidth(msg)

  local pad = 2
  local bw  = tw + pad * 2
  local tail = center("﹀", bw)

  local lines = {
    "╭" .. string.rep("─", bw) .. "╮",
    "│" .. string.rep(" ", pad) .. msg .. string.rep(" ", pad) .. "│",
    "╰" .. string.rep("─", bw) .. "╯",
    tail,
  }
  for _, l in ipairs(ART) do
    table.insert(lines, l)
  end

  local inner_w = math.max(bw + 2, ART_W)
  local height  = #lines
  for i, l in ipairs(lines) do
    lines[i] = center(l, inner_w)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden  = "wipe"

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    row      = vim.o.lines - height - 3,
    col      = vim.o.columns - inner_w - 4,
    width    = inner_w,
    height   = height,
    style    = "minimal",
    border   = "none",
    zindex   = 100,
  })

  vim.api.nvim_set_hl(0, "PetFg",   { fg = COLORS.pet })
  vim.api.nvim_set_hl(0, "PetText", { fg = COLORS.text })

  local art_start = #lines - #ART
  for i = 1, art_start do
    vim.api.nvim_buf_add_highlight(buf, -1, "PetFg", i - 1, 0, -1)
  end
  vim.api.nvim_buf_add_highlight(buf, -1, "PetText", 1, 0, -1)

  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, 6000)
end

-- Saludo en cada arranque del editor (una vez por sesión).
vim.api.nvim_create_autocmd("VimEnter", {
  group    = vim.api.nvim_create_augroup("PetGreeting", { clear = true }),
  callback = function()
    -- Pequeña espera para que el dashboard/plugins pinten antes.
    vim.defer_fn(M.greet, 250)
  end,
})

-- Reinvocar la mascota cuando se quiera.
vim.api.nvim_create_user_command("Pet", M.greet, { desc = "Muestra la mascota que saluda" })

return M