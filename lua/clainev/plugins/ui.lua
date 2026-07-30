-- ════════════════════════════════════════════════════════════════════
--  UI PLUGINS
--  catppuccin · lualine · bufferline · neo-tree · dashboard
--  which-key · indent-blankline · nvim-colorizer
-- ════════════════════════════════════════════════════════════════════

-- ── THEME ─────────────────────────────────────────────────────────
return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    opts     = {
      flavour                = "mocha",
      transparent_background = false,
      term_colors            = true,
      integrations           = {
        cmp              = true,
        gitsigns         = true,
        nvimtree         = false,
        neo_tree         = true,
        treesitter       = true,
        telescope        = { enabled = true },
        which_key        = true,
        indent_blankline = { enabled = true },
        mason            = true,
        lsp_trouble      = true,
        bufferline       = true,
      },
    },
    config   = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },

  -- ── STATUSLINE ────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "auto",
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        disabled_filetypes   = { statusline = { "dashboard", "lazy" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── TABLINE ───────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    version      = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts         = {
      options = {
        mode                    = "buffers",
        numbers                 = "none",
        close_command           = "bdelete! %d",
        diagnostics             = "nvim_lsp",
        separator_style         = "slant",
        show_buffer_close_icons = true,
        show_close_icon         = false,
        always_show_bufferline  = true,
        offsets                 = {
          {
            filetype  = "neo-tree",
            text      = "  Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- ── FILE EXPLORER ─────────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    cmd          = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts         = {
      close_if_last_window = true,
      window               = {
        position = "left",
        width = 30,
      },
      filesystem           = {
        filtered_items         = {
          hide_dotfiles   = false,
          hide_gitignored = false,
          hide_by_name    = { "node_modules", ".DS_Store" },
        },
        async_directory_scan   = "always",
        scan_mode              = "shallow",
        follow_current_file    = { enabled = true },
        use_libuv_file_watcher = false,
      },
    },
  },

  -- ── DASHBOARD ─────────────────────────────────────────────────────
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts         = function()
      -- Menú en rejilla (2 columnas) en vez de una lista vertical larga.
      --
      -- El tema doom de dashboard-nvim pinta exactamente un item por línea
      -- y cuelga la tecla al final con virt_text, así que una rejilla no se
      -- puede expresar con su `center`. Lo que hacemos: cada entrada del
      -- `center` es UNA FILA ya maquetada con varias celdas dentro, y las
      -- teclas y los colores de cada celda se aplican a mano al cargar el
      -- buffer (autocmd User DashboardLoaded, más abajo).
      local items = {
        { icon = "  ", key = "f", desc = "Find File",    action = "Telescope find_files" },
        { icon = "  ", key = "w", desc = "Find Word",    action = "Telescope live_grep" },
        { icon = "  ", key = "r", desc = "Recent Files", action = "Telescope oldfiles" },
        { icon = "  ", key = "e", desc = "Explorer",     action = "Neotree toggle" },
        { icon = "  ", key = "g", desc = "LazyGit",      action = "LazyGit" },
        { icon = "󰒲  ", key = "l", desc = "Lazy",         action = "Lazy" },
        { icon = "  ", key = "m", desc = "Mason",        action = "Mason" },
        { icon = "󰗼  ", key = "q", desc = "Quit",         action = "qa" },
      }

      local COLS = 2 -- celdas por fila
      local GAP  = "    "

      -- Ancho de la etiqueta más larga, para que las columnas cuadren.
      local label_w = 0
      for _, it in ipairs(items) do
        label_w = math.max(label_w, vim.api.nvim_strwidth(it.desc))
      end

      -- Construye las filas guardando, por celda, los offsets en BYTES
      -- del icono y de la tecla dentro de la fila. Como el relleno que
      -- añade dashboard para centrar son espacios (1 byte), luego basta
      -- con sumar el ancho del sangrado para tener la posición real.
      local rows, marks = {}, {}
      for i = 1, #items, COLS do
        local cells, row_marks, off = {}, {}, 0
        for j = i, math.min(i + COLS - 1, #items) do
          local it    = items[j]
          local pad   = (" "):rep(label_w - vim.api.nvim_strwidth(it.desc))
          local label = it.desc .. pad
          local key   = ("[%s]"):format(it.key)
          local cell  = it.icon .. label .. "  " .. key

          table.insert(row_marks, {
            icon_s = off,
            icon_e = off + #it.icon,
            key_s  = off + #it.icon + #label + 2,
            key_e  = off + #it.icon + #label + 2 + #key,
          })

          table.insert(cells, cell)
          off = off + #cell + #GAP
        end
        table.insert(rows, table.concat(cells, GAP))
        table.insert(marks, row_marks)
      end

      -- Cada fila entra como un item del center. `action` es la del primer
      -- elemento de la fila, que es lo que dispara <CR> al estar encima.
      local center = {}
      for idx, row in ipairs(rows) do
        center[idx] = { desc = row, action = items[(idx - 1) * COLS + 1].action }
      end

      return {
        theme = "doom",
        config = {
          header = {
            "",
            "  ████                    ████",
            "  ██░░██                ██░░██",
            "  ██░░████████████████████░░██",
            "████████████████████████████████",
            "████    ████████████████    ████",
            "██░░░░░░████████████████░░░░░░██",
            "██░░░░░░░░░░░░    ░░░░░░░░░░░░██",
            "  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░",
            "    ████░░░░░░░░░░░░░░░░████",
            "  ██████░░░░░░░░░░░░░░░░██████    ░░░░",
            "  ████████░░░░░░░░░░░░████████  ██░░░░░░",
            "  ████    ████████    ████      ██████",
            "",
            "        Web · Mobile · Desktop · Systems · Data        ",
            "",
          },
          center = center,
          footer = { "", "  Clainev — ship fast, measure, iterate" },
        },
        -- Consumido por el autocmd de abajo, no por dashboard-nvim.
        _grid = { items = items, rows = rows, marks = marks, cols = COLS },
      }
    end,
    config       = function(_, opts)
      local grid = opts._grid
      opts._grid = nil
      require("dashboard").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        group   = vim.api.nvim_create_augroup("DashboardGrid", { clear = true }),
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype ~= "dashboard" then
            return
          end

          -- Teclas: doom sólo registra las de items con `key`, y aquí las
          -- filas no lo llevan, así que las mapeamos todas nosotros.
          for _, it in ipairs(grid.items) do
            vim.keymap.set("n", it.key, function()
              if type(it.action) == "function" then
                it.action()
              else
                vim.cmd(it.action)
              end
            end, { buffer = buf, nowait = true, silent = true, desc = "Dashboard: " .. it.desc })
          end

          -- Colores por celda: el icono y la tecla de cada una, que si no
          -- heredarían el highlight de la fila entera.
          local ns    = vim.api.nvim_create_namespace("DashboardGrid")
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          for r, row in ipairs(grid.rows) do
            for lnum, line in ipairs(lines) do
              local s = line:find(row, 1, true)
              if s then
                local indent = s - 1
                for _, m in ipairs(grid.marks[r]) do
                  vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, indent + m.icon_s, {
                    end_col = indent + m.icon_e,
                    hl_group = "DashboardIcon",
                  })
                  vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, indent + m.key_s, {
                    end_col = indent + m.key_e,
                    hl_group = "DashboardKey",
                  })
                end
                break
              end
            end
          end
        end,
      })
    end,
  },

  -- ── WHICH-KEY ─────────────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    opts   = { icons = { separator = "→", group = "+" } },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      wk.add {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>x", group = "Trouble" },
        { "<leader>t", group = "Terminal/Tabs" },
        { "<leader>a", group = "AI" },
        { "<leader>d", group = "Debug" },
        { "<leader>n", group = "Tests" },
        { "<leader>s", group = "Split/Session" },
        { "<leader>D", group = "Database" },
        { "<leader>R", group = "REST (.http)" },
        { "<leader>F", group = "Flutter" },
      }
    end,
  },

  -- ── INDENT GUIDES ─────────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      indent  = { char = "│" },
      scope   = { char = "│" },
      exclude = { filetypes = { "help", "lazy", "mason", "dashboard" } },
    },
  },

  -- ── COLOR HIGHLIGHTER ─────────────────────────────────────────────
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      user_default_options = { tailwind = true, css = true, names = false },
    },
  },
}
