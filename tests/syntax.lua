-- Comprueba que todos los ficheros Lua de la config parseen.
-- Corre sin plugins ni red: es la barrera barata antes del test de arranque.
--   nvim --headless -l tests/syntax.lua

local files = vim.fn.glob("init.lua", true, true)
vim.list_extend(files, vim.fn.glob("lua/**/*.lua", true, true))
vim.list_extend(files, vim.fn.glob("tests/*.lua", true, true))

local failed = 0
for _, file in ipairs(files) do
  local _, err = loadfile(file)
  if err then
    failed = failed + 1
    print(("  %s\n    %s"):format(file, err))
  end
end

print(("%d ficheros revisados, %d con errores de sintaxis"):format(#files, failed))

if failed > 0 then
  os.exit(1)
end
