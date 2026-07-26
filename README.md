<div align="center">

```
 ██████╗██╗      █████╗ ██╗███╗   ██╗███████╗██╗   ██╗
██╔════╝██║     ██╔══██╗██║████╗  ██║██╔════╝██║   ██║
██║     ██║     ███████║██║██╔██╗ ██║█████╗  ██║   ██║
██║     ██║     ██╔══██║██║██║╚██╗██║██╔══╝  ╚██╗ ██╔╝
╚██████╗███████╗██║  ██║██║██║ ╚████║███████╗ ╚████╔╝
 ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝  ╚═══╝
```

**Clainev Neovim Config**

A fast, modular Neovim setup for full-stack and systems development.

[![CI](https://github.com/27te/27nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/27te/27nvim/actions/workflows/ci.yml)
![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?style=flat&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?style=flat&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat)
![Windows](https://img.shields.io/badge/Windows-native-0078D4?style=flat&logo=windows&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![macOS](https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white)

</div>

---

## Stack

`TypeScript` · `JavaScript` · `React` · `Go` · `Rust` · `Python` · `PHP/Laravel` · `Java/Spring` · `Bun/Elysia` · `C/C++` · `Dart/Flutter` · `SQL`

**Infra/DevOps:** `Docker` · `docker-compose` · `Kubernetes/Helm` · `Nginx` · `GraphQL` · `gRPC/protobuf` · `Bash/PowerShell` · `YAML/TOML`

**IDE:** LSP + autocompletado · Debugger (DAP) · Test runner (neotest) · REST client (`.http`) · Database UI · Git · Sesiones

## Requirements

- Neovim >= 0.10
- Git
- [Nerd Font](https://www.nerdfonts.com/) — any variant
- `cmake` (for telescope-fzf-native on Windows)
- `node` + `npm` (for LSP servers and formatters)
- `ripgrep` + `fd` (Telescope live grep)
- **Opcionales por stack:** JDK 21+ (`jdtls` Java LSP) · `cargo-nextest` (tests de Rust con neotest) · `lazydocker` (UI de Docker) · Xdebug (debug de PHP)

## Installation

### Linux / macOS

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone git@github.com:TU-USER/TU-REPO.git ~/.config/nvim

# Open Neovim — plugins install automatically
nvim
```

### Windows (Native — Scoop)

> Tested on Windows 10/11 with PowerShell. No WSL required.

**1. Install Scoop** (if not already installed):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

**2. Install dependencies:**

```powershell
# Add buckets
scoop bucket add extras
scoop bucket add nerd-fonts

# Core
scoop install git neovim nodejs cmake

# Nerd Font (pick one)
scoop install nerd-fonts/JetBrainsMono-NF

# Optional but recommended
scoop install lazygit ripgrep fd
```

**3. Clone the config:**

```powershell
# Backup existing config
if (Test-Path $env:LOCALAPPDATA\nvim) {
    Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
}

# Clone
git clone git@github.com:TU-USER/TU-REPO.git $env:LOCALAPPDATA\nvim
```

**4. Set API keys** (PowerShell — add to your `$PROFILE` to persist):

```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-..."
$env:OPENAI_API_KEY    = "sk-..."     # optional
```

To make them permanent via GUI: `Win + R` → `sysdm.cpl` → Advanced → Environment Variables.

**5. Open Neovim:**

```powershell
nvim
```

Lazy.nvim bootstraps itself, installs all plugins, then Mason installs LSP servers and formatters automatically.

> **Note:** `telescope-fzf-native` requires `cmake` on Windows. The config detects the OS automatically and uses the correct build command.

---

Lazy.nvim bootstraps itself on first launch and installs all plugins. LSP servers and formatters install via Mason.

## Structure

```
~/.config/nvim/
├── init.lua                     # Entry point
└── lua/clainev/
    ├── options.lua              # vim.opt settings
    ├── lazy.lua                 # Plugin manager bootstrap
    ├── keymaps.lua              # Global keymaps
    ├── autocmds.lua             # Autocommands
    └── plugins/
        ├── ui.lua               # Theme, statusline, explorer, dashboard
        ├── editor.lua           # Telescope, Treesitter, editing utilities
        ├── lsp.lua              # LSP servers, Mason, diagnostics, formatter
        ├── completion.lua       # nvim-cmp, LuaSnip, SQL/cmdline completion
        ├── dap.lua              # Debugger (nvim-dap + UI + adapters)
        ├── test.lua             # Test runner (neotest + adapters)
        ├── git.lua              # Gitsigns, LazyGit, Trouble
        ├── tools.lua            # Terminal, REST client, sessions, linters
        ├── ai.lua               # Avante (proveedor gratuito)
        └── flutter.lua          # Flutter tools
```

## Plugins

| Category | Plugin |
|---|---|
| Theme | [catppuccin](https://github.com/catppuccin/nvim) — Mocha |
| Statusline | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) |
| Tabline | [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) |
| Explorer | [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) |
| Fuzzy finder | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim) |
| Completion | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| Formatter | [conform.nvim](https://github.com/stevearc/conform.nvim) |
| Debugger | [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) |
| Tests | [neotest](https://github.com/nvim-neotest/neotest) — pytest · Jest · Vitest · go test · cargo nextest · Pest |
| REST client | [kulala.nvim](https://github.com/mistweaverco/kulala.nvim) — archivos `.http` |
| Database | [vim-dadbod](https://github.com/tpope/vim-dadbod) + UI + completion |
| JSON/YAML schemas | [schemastore.nvim](https://github.com/b0o/SchemaStore.nvim) — K8s, compose, GitHub Actions |
| Extra linters | [nvim-lint](https://github.com/mfussenegger/nvim-lint) — hadolint |
| Sessions | [persistence.nvim](https://github.com/folke/persistence.nvim) |
| Git | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) + [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) |
| Diagnostics | [trouble.nvim](https://github.com/folke/trouble.nvim) |
| Terminal | [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) + lazydocker |
| AI | [avante.nvim](https://github.com/yetone/avante.nvim) (proveedor gratuito por defecto) |
| Flutter | [flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim) |

## Keymaps

`<leader>` = `Space`

### General

| Key | Action |
|---|---|
| `<C-s>` | Save |
| `<C-q>` | Quit |
| `jk` | Exit insert mode |
| `<C-a>` | Select all |
| `zz` | Quit without saving |
| `zw` | Save and quit |

### Navigation

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move between windows |
| `<Tab>` / `<S-Tab>` | Next / prev buffer |
| `H` / `L` | Prev / next tab |
| `<leader>x` | Close buffer |

### Find (Telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fo` | Recent files |
| `<leader>fh` | Help tags |

### LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>lf` | Format file |
| `[d` / `]d` | Prev / next diagnostic |

### Git

| Key | Action |
|---|---|
| `<leader>gg` | LazyGit |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gs` | Stage hunk |
| `<leader>gd` | Diff this |

### Tools

| Key | Action |
|---|---|
| `<leader>e` | Toggle explorer |
| `<leader>th/tv/tf` | Terminal horizontal / vertical / float |
| `<leader>td` | LazyDocker (float) |
| `<leader>xx` | Trouble diagnostics |
| `<leader>u` | Undo tree |
| `<leader>Du` | Database UI (dadbod) |
| `<leader>Da` | Add DB connection |
| `<leader>sr` / `<leader>sl` | Restore session (cwd / last) |

### Debug (DAP)

| Key | Action |
|---|---|
| `<F5>` | Continue / Start |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>du` | Toggle debug UI |
| `<leader>de` | Eval under cursor |
| `<leader>dt` | Terminate |

### Tests (neotest)

| Key | Action |
|---|---|
| `<leader>nn` | Run nearest test |
| `<leader>nf` | Run file tests |
| `<leader>nd` | Debug nearest test |
| `<leader>ns` | Toggle summary |
| `<leader>no` | Show output |
| `<leader>nw` | Watch file |

### REST client (kulala — archivos `.http`)

| Key | Action |
|---|---|
| `<leader>Rs` | Send request |
| `<leader>Ra` | Send all |
| `<leader>Rr` | Replay last |
| `<leader>Rc` | Copy as cURL |

### AI (Avante)

| Key | Action |
|---|---|
| `<leader>aa` | Ask AI |
| `<leader>ac` | AI Chat |
| `<leader>ae` | AI Edit |

### Flutter

| Key | Action |
|---|---|
| `<leader>Fr` | Flutter run |
| `<leader>FR` | Hot reload |
| `<leader>Fd` | Devices |
| `<leader>FL` | Logs |

## LSP Servers

Installed automatically via Mason:

`ts_ls` · `eslint` · `html` · `cssls` · `tailwindcss` · `emmet_ls` · `jsonls` · `intelephense` · `pyright` · `ruff` · `gopls` · `rust_analyzer` · `jdtls` · `lemminx` · `clangd` · `dartls` · `lua_ls` · `sqls` · `graphql` · `buf_ls` · `marksman` · `yamlls` · `taplo` · `dockerls` · `docker_compose_language_service` · `helm_ls` · `bashls` · `powershell_es`

> `jdtls` (Java) requiere JDK 21+ en el PATH. Nginx tiene highlighting vía treesitter (su LSP requiere Python <3.14).

## Formatters

Installed via Mason. Format on save enabled.

`prettier` · `black` · `ruff` (imports) · `gofumpt` · `goimports` · `rustfmt` · `google-java-format` · `clang-format` · `stylua` · `php-cs-fixer` · `sqlfmt` · `shfmt` · `buf` · `dart_format`

## Debug adapters (DAP)

Installed via Mason:

`debugpy` (Python) · `delve` (Go) · `codelldb` (Rust/C/C++) · `js-debug-adapter` (Node/TS) · `php-debug-adapter` (Xdebug, puerto 9003)

## AI Setup

Avante uses Claude by default. Set your API keys as environment variables.

**Linux / macOS** — add to `.bashrc` / `.zshrc`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."  # optional
```

**Windows** — add to PowerShell `$PROFILE`:

```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-..."
$env:OPENAI_API_KEY    = "sk-..."     # optional
```

Or permanently via: `Win + R` → `sysdm.cpl` → Advanced → Environment Variables.

## Testing

CI runs on every push against Neovim **stable** and **nightly**, so an upstream
breaking change surfaces here before it breaks your editor.

```bash
# Cheap: does every Lua file parse? No plugins, no network.
nvim --headless -l tests/syntax.lua

# Real: install plugins, then assert the config boots clean.
nvim --headless "+Lazy! sync" +qa
nvim --headless -c "lua dofile('tests/health.lua')" -c 'qa!'
```

`tests/health.lua` checks the things that break silently: that all four root
modules load, that `mapleader` is set *before* lazy.nvim (otherwise every plugin
keymap binds to the wrong key), that OS detection ran, and that fewer than half
the plugins load at startup — if that ratio slips, something lost its
`event`/`ft` guard and startup time is quietly degrading.

---

<div align="center">
  <sub>Clainev — ship fast, measure, iterate</sub>
</div>
