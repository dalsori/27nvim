-- ════════════════════════════════════════════════════════════════════
--  LSP
--  mason · mason-lspconfig · mason-tool-installer · nvim-lspconfig
--  schemastore · conform · fidget
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "williamboman/mason.nvim",
    cmd  = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      { "williamboman/mason-lspconfig.nvim", opts = {} },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
      { "j-hui/fidget.nvim",                 opts = {} },
    },
    config = function()
      -- Shared capabilities
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Keymaps on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group    = vim.api.nvim_create_augroup("ClainevLspKeys", { clear = true }),
        callback = function(event)
          local map     = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local builtin = require "telescope.builtin"

          map("gd",          builtin.lsp_definitions,     "Go to Definition")
          map("gD",          vim.lsp.buf.declaration,      "Go to Declaration")
          map("gr",          builtin.lsp_references,       "References")
          map("gi",          builtin.lsp_implementations,  "Implementations")
          map("gt",          builtin.lsp_type_definitions, "Type Definition")
          map("K",           vim.lsp.buf.hover,            "Hover Docs")
          map("<leader>ca",  vim.lsp.buf.code_action,      "Code Action")
          map("<leader>rn",  vim.lsp.buf.rename,           "Rename Symbol")
          map("<leader>lf",  function() vim.lsp.buf.format { async = true } end, "Format")
          map("<leader>li",  "<cmd>LspInfo<CR>",           "LSP Info")
          map("<leader>lr",  "<cmd>LspRestart<CR>",        "LSP Restart")
          map("[d",          function() vim.diagnostic.jump { count = -1, float = true } end, "Prev Diagnostic")
          map("]d",          function() vim.diagnostic.jump { count = 1, float = true } end,  "Next Diagnostic")
          map("<leader>ld",  vim.diagnostic.open_float,    "Line Diagnostics")

          -- Inlay hints (Neovim 0.10+)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method "textDocument/inlayHint" then
            map("<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "Toggle Inlay Hints")
          end
        end,
      })

      -- ── Server list ───────────────────────────────────────────────
      local servers = {
        -- Web / TypeScript / JavaScript (NestJS, Elysia, React)
        ts_ls       = {
          settings = {
            typescript = { inlayHints = {
              includeInlayParameterNameHints          = "all",
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayVariableTypeHints           = true,
            }},
            javascript = { inlayHints = {
              includeInlayParameterNameHints = "all",
            }},
          },
        },
        eslint      = {},
        html        = {},
        cssls       = {},
        emmet_ls    = {},
        tailwindcss = {},
        jsonls      = {
          settings = {
            json = {
              schemas  = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- PHP / Laravel
        intelephense = {},

        -- Python (Flask, FastAPI): pyright = tipos, ruff = lint/imports
        pyright = {
          settings = {
            python = { analysis = { typeCheckingMode = "basic", autoSearchPaths = true } },
          },
        },
        ruff = {},

        -- Go
        gopls = {
          settings = {
            gopls = {
              analyses    = { unusedparams = true },
              staticcheck = true,
              gofumpt     = true,
              hints       = {
                parameterNames      = true,
                assignVariableTypes = true,
                rangeVariableTypes  = true,
              },
            },
          },
        },

        -- Rust (Axum, SQLx)
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = true,
              check       = { command = "clippy" },
              cargo       = { allFeatures = true },
              inlayHints  = {
                parameterHints = { enable = true },
                typeHints      = { enable = true },
                chainingHints  = { enable = true },
              },
            },
          },
        },

        -- Java / Spring Boot (jdtls necesita JDK 21+ en PATH)
        jdtls   = {},
        lemminx = {},  -- XML: pom.xml, configs

        -- C/C++
        clangd = {},

        -- SQL
        sqls = {},

        -- APIs avanzadas: GraphQL · gRPC/protobuf
        graphql = {},
        buf_ls  = {},

        -- Dart / Flutter (managed by flutter-tools, kept here for fallback)
        dartls = {},

        -- Markdown
        marksman = {},

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime     = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace   = {
                library         = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        -- Infra / DevOps: Docker, Compose, Kubernetes, Helm, YAML
        -- (Nginx: highlighting via treesitter; su LSP requiere Python <3.14)
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },  -- schemastore.nvim lo maneja
              schemas     = vim.tbl_deep_extend("force",
                require("schemastore").yaml.schemas(),
                {
                  kubernetes = {
                    "*deployment*.{yml,yaml}", "*service*.{yml,yaml}",
                    "*ingress*.{yml,yaml}", "*configmap*.{yml,yaml}",
                    "*secret*.{yml,yaml}", "**/k8s/**/*.{yml,yaml}",
                    "**/kubernetes/**/*.{yml,yaml}", "**/manifests/**/*.{yml,yaml}",
                  },
                }),
              format = { enable = false },
            },
          },
        },
        taplo                            = {},
        dockerls                         = {},
        docker_compose_language_service  = {},
        helm_ls                          = {},
        bashls                           = {},
        -- bundle_path explícito: el default de mason-lspconfig usa la var
        -- $MASON, que a veces no está definida al construir el `cmd` y
        -- produce "nil/PowerShellEditorServices/Start-EditorServices.ps1"
        powershell_es = {
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        },
      }

      local ensure_installed = vim.tbl_filter(function(server)
        return server ~= "dartls"
      end, vim.tbl_keys(servers))

      require("mason-lspconfig").setup {
        ensure_installed = ensure_installed,
      }

      -- Formatters · linters · debug adapters (no-LSP) via Mason
      require("mason-tool-installer").setup {
        ensure_installed = {
          -- formatters
          "prettier", "stylua", "black", "php-cs-fixer",
          "google-java-format", "shfmt", "clang-format", "sqlfmt",
          "gofumpt", "goimports", "buf",
          -- linters
          "hadolint", "shellcheck",
          -- debug adapters (DAP)
          "debugpy", "delve", "codelldb", "js-debug-adapter", "php-debug-adapter",
        },
        run_on_start = true,
      }

      -- Solo habilitar servidores que mason tiene instalados: si se llama
      -- vim.lsp.enable() sobre un servidor no instalado, nvim valida su `cmd`
      -- y lanza el error "invalid <server> config ... is not executable".
      local installed_servers = require("mason-lspconfig").get_installed_servers()
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        if vim.list_contains(installed_servers, server) then
          vim.lsp.enable(server)
        end
      end

      -- Diagnostic icons
      vim.diagnostic.config {
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
          },
        },
        virtual_text  = { prefix = "●" },
        float         = { border = "rounded", source = "if_many" },
        underline     = true,
        update_in_insert = false,
      }
    end,
  },

  -- ── FORMATTER ─────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts  = {
      format_on_save = { timeout_ms = 1500, lsp_fallback = true },
      formatters_by_ft = {
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        html            = { "prettier" },
        css             = { "prettier" },
        scss            = { "prettier" },
        json            = { "prettier" },
        jsonc           = { "prettier" },
        yaml            = { "prettier" },
        markdown        = { "prettier" },
        graphql         = { "prettier" },
        php             = { "php_cs_fixer" },
        -- isort roto en Windows (--line-ending con CRLF); ruff ordena imports
        python          = { "ruff_organize_imports", "black" },
        go              = { "gofumpt", "goimports" },
        rust            = { "rustfmt" },
        java            = { "google_java_format" },
        proto           = { "buf" },
        c               = { "clang_format" },
        cpp             = { "clang_format" },
        lua             = { "stylua" },
        sql             = { "sqlfmt" },
        sh              = { "shfmt" },
        bash            = { "shfmt" },
        dart            = { "dart_format" },
      },
      formatters = {
        prettier = { prepend_args = { "--print-width", "100", "--single-quote", "--trailing-comma", "es5" } },
        black    = { prepend_args = { "--line-length", "100" } },
        stylua   = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
        shfmt    = { prepend_args = { "-i", "2" } },
      },
    },
  },
}
