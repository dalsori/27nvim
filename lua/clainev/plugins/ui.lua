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
    opts         = {
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
        center = {
          { icon = "  ", key = "f", desc = "Find File", action = "Telescope find_files" },
          { icon = "  ", key = "w", desc = "Find Word", action = "Telescope live_grep" },
          { icon = "  ", key = "r", desc = "Recent Files", action = "Telescope oldfiles" },
          { icon = "  ", key = "e", desc = "Explorer", action = "Neotree toggle" },
          { icon = "  ", key = "g", desc = "LazyGit", action = "LazyGit" },
          { icon = "󰒲  ", key = "l", desc = "Lazy", action = "Lazy" },
          { icon = "  ", key = "m", desc = "Mason", action = "Mason" },
          { icon = "󰗼  ", key = "q", desc = "Quit", action = "qa" },
        },
        footer = { "", "  Clainev — ship fast, measure, iterate" },
      },
    },
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
