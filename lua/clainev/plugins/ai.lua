-- ════════════════════════════════════════════════════════════════════
--  AI
--  avante.nvim (sidebar de chat/agente) + copilot.lua (autocompletado inline)
--
--  Proveedor por defecto: GitHub Copilot (gratis, sin API key).
--    Primera vez: ejecuta :Copilot auth → login por navegador → reinicia nvim.
--    Autocompletado inline (ghost text): Tab / <M-l> para aceptar.
--
--  NOTA: el copilot.lua moderno guarda el login en auth.db (SQLite),
--  pero avante solo lee el formato viejo hosts.json. El bloque
--  sync_copilot_token() de abajo hace de puente: extrae el token de
--  auth.db, lo valida contra GitHub y genera el hosts.json que avante
--  espera. Es automático; solo requiere haber hecho :Copilot auth.
--
--  Alternativas gratuitas (requieren key gratuita, se cambian con
--  :AvanteSwitchProvider gemini / groq):
--    · gemini → key gratis en https://aistudio.google.com/apikey
--               (variable de entorno GEMINI_API_KEY)
--    · groq   → key gratis en https://console.groq.com/keys
--               (variable de entorno GROQ_API_KEY)
-- ════════════════════════════════════════════════════════════════════

-- Monkey-patch para normalizar rutas temporales en Windows (plenary.path se parcha en config)
if vim.fn.has("win32") == 1 then
  -- 1. Normalizar vim.fn.tempname para usar barras invertidas de Windows
  local original_tempname = vim.fn.tempname
  vim.fn.tempname = function()
    local temp = original_tempname()
    if temp then
      return temp:gsub("/", "\\")
    end
    return temp
  end
end

-- Genera hosts.json (formato que lee avante) a partir del auth.db del
-- copilot.lua moderno. Devuelve true si Copilot queda autenticado.
local function sync_copilot_token()
  local dir = vim.fn.has("win32") == 1
      and vim.fn.expand("$LOCALAPPDATA/github-copilot")
      or vim.fn.expand("~/.config/github-copilot")
  local hosts = dir .. "/hosts.json"
  if vim.fn.filereadable(hosts) == 1 then return true end

  -- Extraer posibles tokens (gho_/ghu_/ghp_) del auth.db y su WAL
  local candidates, seen = {}, {}
  for _, file in ipairs({ dir .. "/auth.db-wal", dir .. "/auth.db" }) do
    local fd = io.open(file, "rb")
    if fd then
      local data = fd:read("*a")
      fd:close()
      for token in data:gmatch("gh[oup]_[%w_]+") do
        -- Los tokens de GitHub miden 40 chars; el registro SQLite puede
        -- tener bytes alfanuméricos de basura pegados al final.
        token = token:sub(1, 40)
        if #token == 40 and not seen[token] then
          seen[token] = true
          table.insert(candidates, token)
        end
      end
    end
  end

  -- Validar cada candidato contra la API de GitHub (una sola vez;
  -- después existe hosts.json y este bloque no vuelve a correr)
  for _, token in ipairs(candidates) do
    local status = vim.fn.system({
      "curl", "-s", "-o", vim.fn.has("win32") == 1 and "NUL" or "/dev/null",
      "-w", "%{http_code}", "--max-time", "5",
      "-H", "Authorization: token " .. token,
      "https://api.github.com/user",
    })
    if vim.trim(status) == "200" then
      local fd = io.open(hosts, "w")
      if fd then
        fd:write(string.format('{"github.com":{"user":"nvim","oauth_token":"%s"}}', token))
        fd:close()
        return true
      end
    end
  end
  return false
end

return {
  {
    "yetone/avante.nvim",
    event        = "VeryLazy",
    version      = false, -- always use the latest version
    build        = vim.g.is_windows
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "HakonHarnes/img-clip.nvim",
      "stevearc/dressing.nvim",
      "hrsh7th/nvim-cmp",
      {
        -- Autocompletado inline (ghost text) + backend de auth para avante.
        "zbirenbaum/copilot.lua",
        cmd   = "Copilot",
        event = "InsertEnter",
        opts  = {
          suggestion = {
            enabled      = true,
            auto_trigger = true,
            keymap = {
              accept = "<M-l>",
              next   = "<M-]>",
              prev   = "<M-[>",
              dismiss = "<C-]>",
            },
          },
          panel = { enabled = true },
          filetypes = {
            markdown = true,
            help     = false,
            gitcommit = true,
            ["."] = true,
          },
        },
      },
    },
    opts         = {
      provider                  = "copilot",
      auto_suggestions_provider = "copilot",
      providers                 = {
        copilot = {
          model = "gpt-4.1",
        },
        gemini = {
          model        = "gemini-2.5-flash",
          api_key_name = "GEMINI_API_KEY",
        },
        groq = {
          __inherited_from = "openai",
          endpoint         = "https://api.groq.com/openai/v1",
          model            = "llama-3.3-70b-versatile",
          api_key_name     = "GROQ_API_KEY",
        },
        claude = {
          model        = "claude-sonnet-4-6",
          api_key_name = "ANTHROPIC_API_KEY",
        },
        openai = {
          model        = "gpt-4o",
          api_key_name = "OPENAI_API_KEY",
        },
      },
      behaviour                 = {
        auto_suggestions      = false,
        auto_set_keymaps      = true,
        -- Agregar automáticamente el archivo desde el que se abre avante
        -- al contexto del chat, para que la IA trabaje sobre él en vez
        -- de crear archivos nuevos.
        auto_add_current_file = true,
      },
      windows                   = {
        width          = 35,
        sidebar_header = { rounded = true },
      },
    },
    config       = function(_, opts)
      -- Validar/sincronizar token de Copilot. Si no hay login, mantener
      -- copilot como provider pero avisar; cambiar a gemini solo si hay
      -- GEMINI_API_KEY, de lo contrario avante mostraría "provider not configured".
      local has_copilot = sync_copilot_token()
      if not has_copilot then
        local has_gemini = os.getenv("GEMINI_API_KEY") and os.getenv("GEMINI_API_KEY") ~= ""
        local has_groq = os.getenv("GROQ_API_KEY") and os.getenv("GROQ_API_KEY") ~= ""
        if has_gemini then
          opts.provider = "gemini"
          opts.auto_suggestions_provider = "gemini"
        elseif has_groq then
          opts.provider = "groq"
          opts.auto_suggestions_provider = "groq"
        end
        vim.defer_fn(function()
          vim.notify(
            "[avante] Copilot sin autenticar: ejecuta :Copilot auth, "
            .. "completa el login en el navegador y reinicia nvim"
            .. " (sin GEMINI/GROQ_API_KEY el chat no funcionará hasta autenticar)",
            vim.log.levels.WARN
          )
        end, 500)
      end

      -- 2. Monkey-patch para plenary.path para convertir todas las barras / a \ en Windows.
      -- Esto evita fallos al crear directorios recursivamente (mkdir) debido a barras mezcladas.
      if vim.fn.has("win32") == 1 then
        local ok, Path = pcall(require, "plenary.path")
        if ok then
          local original_new = Path.new
          Path.new = function(self, ...)
            local obj = original_new(self, ...)
            if type(obj) == "table" and obj.filename then
              obj.filename = obj.filename:gsub("/", "\\")
            end
            return obj
          end
        end
      end

      require("avante").setup(opts)

      -- 3. Monkey-patch para el chequeo de permisos de las herramientas de avante.
      -- En Windows compara rutas como texto y mezcla barras / y \
      -- (C:/Users/... vs C:\Users\...), así que siempre niega el acceso.
      -- Normalizamos ambas rutas antes de comparar.
      if vim.fn.has("win32") == 1 then
        local ok_h, Helpers = pcall(require, "avante.llm_tools.helpers")
        local ok_u, AvanteUtils = pcall(require, "avante.utils")
        if ok_h and ok_u then
          local original_check = Helpers.has_permission_to_access
          Helpers.has_permission_to_access = function(abs_path)
            if original_check(abs_path) then return true end
            local function norm(p)
              if not p or p == "" then return "" end
              return (vim.fs.normalize(p):gsub("\\", "/"):lower())
            end
            local ap = norm(abs_path)
            if ap == "" then return false end
            local root = norm(AvanteUtils.get_project_root())
            local cfg = norm(vim.fn.stdpath("config"))
            local in_project = root ~= "" and ap:sub(1, #root) == root
            local in_config = cfg ~= "" and ap:sub(1, #cfg) == cfg
            if not in_project and not in_config then return false end
            local conf = require("avante.config")
            local bypass = conf.behaviour and conf.behaviour.allow_access_to_git_ignored_files
            return bypass or not Helpers.is_ignored(abs_path)
          end
        end
      end
    end,
  },
}
