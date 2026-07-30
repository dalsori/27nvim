<div align="center">

```
  ████                    ████
  ██░░██                ██░░██
  ██░░████████████████████░░██
████████████████████████████████
████    ████████████████    ████
██░░░░░░████████████████░░░░░░██
██░░░░░░░░░░░░    ░░░░░░░░░░░░██
  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ████░░░░░░░░░░░░░░░░████
  ██████░░░░░░░░░░░░░░░░██████    ░░░░
  ████████░░░░░░░░░░░░████████  ██░░░░░░
  ████    ████████    ████      ██████
```

**Clainev Neovim Config**

A fast, modular Neovim setup for full-stack and systems development.

[![CI](https://github.com/dalsori/27nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/dalsori/27nvim/actions/workflows/ci.yml)
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
- `unzip` / `tar` (Mason los usa para descomprimir LSP y formateadores)
- **Opcionales por stack:** JDK 21+ (`jdtls` Java LSP) · `cargo-nextest` (tests de Rust con neotest) · `lazydocker` (UI de Docker) · Xdebug (debug de PHP)

## Installation

En los tres sistemas los pasos son los mismos:

1. Instalar dependencias
2. Respaldar la config existente
3. Clonar este repo en la carpeta de config de Neovim
4. Abrir `nvim` — lazy.nvim y Mason hacen el resto

Elige tu sistema operativo.

### Linux

**1. Dependencias:**

```bash
# Debian / Ubuntu
sudo apt install git nodejs npm ripgrep fd-find cmake unzip

# Fedora
sudo dnf install git nodejs npm ripgrep fd-find cmake unzip

# Arch
sudo pacman -S git nodejs npm ripgrep fd cmake unzip
```

> **Ojo con la versión de Neovim.** Esta config necesita **>= 0.10** y los repos de
> Debian/Ubuntu suelen traer una más vieja. Comprueba con `nvim --version`; si se
> queda corta, usa el AppImage oficial:
>
> ```bash
> curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
> chmod +x nvim-linux-x86_64.appimage
> sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
> ```

En Debian/Ubuntu el binario de `fd` se llama `fdfind`; enlázalo para que Telescope lo encuentre:

```bash
mkdir -p ~/.local/bin && ln -s "$(which fdfind)" ~/.local/bin/fd
```

**2. Instala una [Nerd Font](https://www.nerdfonts.com/)** (p. ej. JetBrainsMono Nerd Font) y actívala en tu terminal. Sin esto los iconos se ven como cuadros.

**3. Clonar y arrancar:**

```bash
# Respaldar config existente (si la hay)
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/dalsori/27nvim.git ~/.config/nvim

nvim
```

### macOS

**1. Dependencias** (con [Homebrew](https://brew.sh/)):

```bash
brew install neovim git node ripgrep fd cmake
brew install --cask font-jetbrains-mono-nerd-font
```

Activa la fuente en tu terminal (Terminal.app, iTerm2, Ghostty, WezTerm…).

**2. Clonar y arrancar:**

```bash
# Respaldar config existente (si la hay)
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/dalsori/27nvim.git ~/.config/nvim

nvim
```

### Windows (Native — Scoop)

> Probado en Windows 10/11 con PowerShell. No hace falta WSL.

**1. Instala Scoop** (si no lo tienes):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

**2. Dependencias:**

```powershell
# Buckets
scoop bucket add extras
scoop bucket add nerd-fonts

# Core
scoop install git neovim nodejs cmake

# Nerd Font (elige una)
scoop install nerd-fonts/JetBrainsMono-NF

# Opcionales pero recomendados
scoop install lazygit ripgrep fd
```

Activa la Nerd Font en tu terminal: Windows Terminal → Settings → tu perfil → Appearance → Font face.

**3. Clonar y arrancar:**

```powershell
# Respaldar config existente (si la hay)
if (Test-Path $env:LOCALAPPDATA\nvim) {
    Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
}

git clone https://github.com/dalsori/27nvim.git $env:LOCALAPPDATA\nvim

nvim
```

> **Nota:** `telescope-fzf-native` necesita `cmake` en Windows. La config detecta el SO automáticamente y usa el comando de build correcto.

---

### Primer arranque

La primera vez que abras `nvim` verás cómo se instala todo: lazy.nvim se
autoinstala, descarga los plugins y después Mason baja los LSP y formateadores.
Tarda un par de minutos y es normal ver algún error transitorio mientras faltan
piezas — reinicia Neovim al terminar.

Luego:

```vim
:Copilot auth      " login de la IA (avante usa GitHub Copilot por defecto)
:checkhealth       " verifica dependencias externas (node, rg, fd, cmake…)
:Lazy              " estado de los plugins
:Mason             " estado de LSP / formateadores
```

La IA no necesita API keys: usa la cuenta de GitHub Copilot. Ver [AI Setup](#ai-setup).

## Actualizar

Cuando se publica una versión nueva de la config (temas, plugins, keymaps, la
mascota del dashboard…), actualizar es un `git pull` en la carpeta de config más
un sync de plugins.

**Linux / macOS:**

```bash
cd ~/.config/nvim
git pull
nvim --headless "+Lazy! sync" +qa    # instala / actualiza / limpia plugins según lazy-lock.json
```

**Windows (PowerShell):**

```powershell
cd $env:LOCALAPPDATA\nvim
git pull
nvim --headless "+Lazy! sync" +qa
```

Después abre `nvim` normal. Si el cambio tocó LSP o formateadores, ejecuta
`:Mason` y revisa que no falte nada; `:checkhealth` sigue siendo la comprobación
rápida de siempre.

### Si `git pull` da conflicto

Pasa cuando editaste archivos de la config a mano. Guarda tus cambios aparte y
vuelve a la versión limpia:

```bash
git stash          # aparta tus cambios locales
git pull
git stash pop      # reaplícalos (resuelve conflictos si los hay)
```

Si no te importa perderlos: `git reset --hard origin/main` — **borra** cualquier
modificación local sin recuperación.

### Versiones de plugins

`lazy-lock.json` fija la versión exacta de cada plugin y viaja en el repo, así
que tras un `git pull` + `:Lazy sync` tienes exactamente el mismo set que quien
publicó la versión. Si quieres subir plugins a lo último por tu cuenta usa
`:Lazy update` — eso reescribe tu `lazy-lock.json` y puede entrar en conflicto en
el siguiente `git pull`.

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

Avante usa **GitHub Copilot** por defecto: no hace falta ninguna API key, solo
una cuenta de Copilot (gratis para estudiantes y proyectos open source). Dentro
de Neovim:

```vim
:Copilot auth
```

Se abre el flujo de login por navegador. La config sincroniza el token de
`copilot.lua` al formato que lee avante, así que con eso queda listo en Linux,
macOS y Windows por igual.

### Otro proveedor (opcional)

Hay otros proveedores ya configurados en `lua/clainev/plugins/ai.lua`: `claude`,
`openai`, `gemini` y `groq`. Exporta la key correspondiente y cambia `provider`
ahí. Si Copilot no está autenticado, la config cae automáticamente a `gemini`
para que avante arranque igual.

| Provider | Variable de entorno |
| --- | --- |
| `claude` | `ANTHROPIC_API_KEY` |
| `openai` | `OPENAI_API_KEY` |
| `gemini` | `GEMINI_API_KEY` |
| `groq` | `GROQ_API_KEY` |

**Linux / macOS** — añade a `.bashrc` / `.zshrc`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."  # optional
```

**Windows** — añade al `$PROFILE` de PowerShell:

```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-..."
$env:OPENAI_API_KEY    = "sk-..."     # optional
```

O de forma permanente vía: `Win + R` → `sysdm.cpl` → Advanced → Environment Variables.

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
