-- ════════════════════════════════════════════════════════════════════
--  EDITOR PLUGINS
--  telescope · treesitter · autopairs · surround
--  mini · todo-comments · undotree · markdown · database
-- ════════════════════════════════════════════════════════════════════

return {

  -- ── FUZZY FINDER ─────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    event        = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = vim.g.is_windows
            and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
            or  "make",
        cond  = function()
          return vim.g.is_windows
              and vim.fn.executable "cmake" == 1
              or  vim.fn.executable "make" == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = {
            "node_modules", ".git/", "dist/", "build/",
            "__pycache__", "*.lock", "vendor/",
          },
          layout_strategy  = "horizontal",
          layout_config    = { prompt_position = "top", width = 0.87, height = 0.80 },
          sorting_strategy = "ascending",
          path_display     = { "truncate" },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      }
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require "telescope.builtin"
      local map     = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files,             { desc = "Find Files" })
      map("n", "<leader>fw", builtin.live_grep,              { desc = "Live Grep" })
      map("n", "<leader>fb", builtin.buffers,                { desc = "Find Buffers" })
      map("n", "<leader>fo", builtin.oldfiles,               { desc = "Recent Files" })
      map("n", "<leader>fh", builtin.help_tags,              { desc = "Help Tags" })
      map("n", "<leader>fd", builtin.diagnostics,            { desc = "Diagnostics" })
      map("n", "<leader>fk", builtin.keymaps,                { desc = "Keymaps" })
      map("n", "<leader>fs", builtin.lsp_document_symbols,   { desc = "LSP Symbols" })
      map("n", "<leader>fS", builtin.lsp_workspace_symbols,  { desc = "Workspace Symbols" })
      map("n", "<leader>fg", builtin.git_commits,            { desc = "Git Commits" })
      map("n", "<leader>fG", builtin.git_branches,           { desc = "Git Branches" })
      map("n", "<leader>f/", function()
        builtin.current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown { winblend = 10, previewer = false }
        )
      end, { desc = "Fuzzy in buffer" })
    end,
  },

  -- ── TREESITTER (rama main — API nueva) ───────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build  = ":TSUpdate",
    lazy   = false,
    config = function()
      -- Requiere tree-sitter CLI + compilador C para compilar parsers
      require("nvim-treesitter").install {
        "html", "css", "javascript", "typescript", "tsx",
        "json", "lua", "python", "go", "rust",
        "c", "cpp", "dart", "php", "java", "groovy",
        "sql", "markdown", "markdown_inline",
        "yaml", "toml", "dockerfile", "helm", "nginx",
        "bash", "powershell", "regex", "graphql", "proto", "http",
        "gomod", "gosum", "gowork", "xml", "ini", "properties",
        "gitignore", "gitcommit", "diff", "vim", "vimdoc",
      }

      -- Activar highlight + indent por buffer (la rama main no lo hace sola)
      vim.api.nvim_create_autocmd("FileType", {
        group    = vim.api.nvim_create_augroup("ClainevTreesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Auto-close HTML/JSX tags
  { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },

  -- ── AUTOPAIRS ────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    opts   = { check_ts = true },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── SURROUND ─────────────────────────────────────────────────────
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

  -- ── mini.nvim utilities ───────────────────────────────────────────
  {
    "echasnovski/mini.nvim",
    version = false,
    config  = function()
      require("mini.comment").setup {}    -- gcc / gc comments
      require("mini.cursorword").setup {} -- highlight word under cursor
    end,
  },

  -- ── TODO COMMENTS ────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
  },

  -- ── UNDO TREE ────────────────────────────────────────────────────
  { "mbbill/undotree", cmd = "UndotreeToggle" },

  -- ── MARKDOWN PREVIEW ─────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft    = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- ── DATABASE CLIENT ───────────────────────────────────────────────
  {
    -- El plugin principal es la UI, no dadbod: los comandos DBUI* los
    -- define ella. Si el spec cuelga de vim-dadbod, lazy sólo crea los
    -- stubs que se listen aquí y :DBUIToggle da E492.
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      -- ft propio: la fuente de cmp se registra en after/plugin, así que
      -- sin esto el autocompletado SQL sólo existiría tras abrir la UI.
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd          = {
      "DB",
      "DBUI",
      "DBUIToggle",
      "DBUIClose",
      "DBUIAddConnection",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
      "DBUILastQueryInfo",
    },
    -- init y no config: plugin/db_ui.vim congela los iconos en tiempo de
    -- carga (`if g:db_ui_use_nerd_fonts`), así que ponerlo después no
    -- tenía efecto.
    init         = function()
      vim.g.db_ui_save_location  = vim.fn.stdpath "data" .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
