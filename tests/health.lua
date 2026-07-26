-- Test de arranque: se ejecuta DESPUES de que init.lua se haya cargado,
-- asi que comprueba el estado real de la config, no solo que el codigo parsee.
--   nvim --headless -c "lua dofile('tests/health.lua')" -c 'qa!'

local errors = {}

local function check(condition, message)
  if not condition then
    table.insert(errors, message)
  end
end

-- Los cuatro modulos raiz deben cargar sin lanzar.
for _, mod in ipairs { "clainev.options", "clainev.keymaps", "clainev.autocmds", "clainev.lazy" } do
  local ok, err = pcall(require, mod)
  check(ok, ("el modulo %s no carga: %s"):format(mod, tostring(err)))
end

-- El leader se fija antes de lazy; si se rompe ese orden, los keymaps
-- de los plugins quedan colgados de la tecla equivocada.
check(vim.g.mapleader == " ", "mapleader deberia ser <space>, es " .. vim.inspect(vim.g.mapleader))

-- Deteccion de SO: la config carga rutas distintas segun plataforma.
check(vim.g.is_windows ~= nil, "vim.g.is_windows sin definir")

local lazy_ok, lazy = pcall(require, "lazy")
check(lazy_ok, "lazy.nvim no carga")

if lazy_ok then
  local stats = lazy.stats()
  print(("plugins: %d registrados, %d cargados al arrancar"):format(stats.count, stats.loaded))
  check(stats.count > 0, "no se registro ningun plugin")
  -- Esta config es lazy a proposito: si casi todo carga al inicio,
  -- algo se colo sin su lazy/event/ft y el arranque se degrada.
  check(
    stats.loaded < stats.count * 0.5,
    ("demasiados plugins cargan al arrancar (%d de %d)"):format(stats.loaded, stats.count)
  )
end

if #errors > 0 then
  print("\nFALLOS:")
  for _, err in ipairs(errors) do
    print("  - " .. err)
  end
  vim.cmd "cq1"
end

print("OK: la config arranca limpia")
