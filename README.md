# 27nvim · Agentic coding

Configuración para **Neovim 0.12+**, adaptada a Windows, Linux y macOS a partir de
[Effective Neovim setup for agentic coding towards 2027](https://www.devas.life/effective-neovim-setup-for-agentic-coding-towards-2027/)
de Takuya Matsuyama ([video](https://youtu.be/BhGWcQtq408)).

Base: [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles/tree/7c50fa72f64aada314c124cea005fd923e9f5c0f/dot_config/nvim),
revisión `7c50fa7`. Los módulos se adaptaron al namespace `clainev`.

## Qué incluye

- `vim.pack` y `nvim-pack-lock.json` versionado: instalaciones reproducibles.
- Solarized Osaka vivid **opaco**, tabline propia, Lualine, Incline, UI2 y tiny-cmdline.
- Snacks para búsquedas, notificaciones, referencias, guías y Lazygit; Oil para archivos.
- Gitsigns, mini.diff (fork `feat/grouping`), CodeDiff y GitLink.
- Blink, mini.pairs, Treesitter, LSP nativo y Conform con formato al guardar.
- Copilot inline y utilidades para pasar archivos y selecciones a agentes externos.
- LSP para web/TS, PHP, Python, Go, Rust, Java, C/C++, SQL, GraphQL, Lua,
  Markdown, YAML, Docker, Helm, Bash y PowerShell. Dart utiliza el SDK local.

## Requisitos e instalación

Neovim >= 0.12, Git, Node/npm, `rg`, `fd`, `tree-sitter`, compilador C, `curl` y `tar`.
Lazygit para `;g`. Una Nerd Font configurada en la terminal para los iconos.
Los SDK de cada lenguaje deben estar instalados aparte.

En Windows, la configuración vive en `$env:LOCALAPPDATA\nvim`.
En Linux/macOS, en `~/.config/nvim`. Respalda una configuración existente antes de clonar:

```powershell
git clone https://github.com/dalsori/27nvim.git "$env:LOCALAPPDATA\nvim"
nvim
```

```sh
git clone https://github.com/dalsori/27nvim.git ~/.config/nvim
nvim
```

Acepta la instalación de plugins al primer arranque. Mason instala herramientas
faltantes; consulta `:Mason` para ver su estado y `:MasonToolsInstallSync` para
esperar la instalación. Treesitter compila los parsers y necesita un compilador C.
En Windows se utiliza GCC cuando MSVC no está disponible.

Copilot necesita una cuenta con acceso y `:Copilot auth` si aún no hay sesión.
No se copian tokens, bases de datos de autenticación ni claves al repositorio.

## Atajos principales

`<leader>` es **Espacio**. El ratón está desactivado.

| Teclas | Acción |
| --- | --- |
| `;f` / `;r` | Buscar archivos / texto, incluyendo ocultos |
| `;;` / `\\` | Reabrir búsqueda / listar buffers |
| `;e` / `;n` | Diagnósticos / notificaciones |
| `sf` | Oil flotante con preview; `h` sube, `q` cierra |
| `;g` / `;h` | Lazygit / lista de cambios |
| `<leader>dv` | CodeDiff: revisión de cambios lado a lado |
| `<leader>dh` / `<leader>dH` | Historial del archivo / repositorio |
| `<leader>gd` | Overlay de mini.diff |
| `]c` / `[c` | Siguiente / anterior cambio |
| `<leader>gb` / `<leader>gB` | Blame de línea / archivo |
| `<leader>gs` / `<leader>gh` | Stage/unstage del archivo / bloque |
| `<leader>go` | Abrir la versión del commit de la línea |
| `gd` / `gD` / `gy` / `gr` | Definición / declaración / tipo / referencias |
| `gI` | Implementación; código fuente con TypeScript |
| `K` / `gK` | Documentación / firma |
| `<C-j>` | Siguiente diagnóstico |
| `<leader>ca` / `<leader>cr` / `<leader>cR` | Acciones / renombrar símbolo / archivo |
| `<leader>f` / `<leader>cl` | Formatear / configuración LSP |
| `<leader>i` | Activar/desactivar inlay hints |
| `<leader>yf` / `<leader>yp` | Copiar ruta relativa / absoluta con `#Llínea` |
| `<leader>cc` en visual | Copiar líneas seleccionadas como bloque Markdown |
| `<leader>j` | Abrir package.json en una ventana flotante |
| `<leader>bd` | Cerrar buffers ocultos, conservando los modificados |
| `te`, `Tab`, `Shift-Tab` | Nueva pestaña / siguiente / anterior |
| `ss` / `sv`, `sh sj sk sl` | Dividir ventanas / cambiar de ventana |
| `<C-s>` / `jk` | Guardar / salir del modo insertar |
| `ZR` | Reiniciar Neovim; guardar antes con `:wa` |

Copilot en modo insertar: `<C-l>` acepta, `Alt-l` acepta una palabra,
`Alt-Shift-l` una línea, `Alt-]`/`Alt-[` cambia sugerencia y `<C-]>` descarta.
Blink usa Enter para aceptar autocompletado y `<C-Space>` para abrirlo.

## Flujo con agentes

1. Ejecuta tu agente en otro panel de terminal y Neovim en el proyecto.
2. Copia una referencia con `<leader>yf` o una selección con `<leader>cc`.
3. Revisa con `;g`, `<leader>dv` y `<leader>gd`; luego decide qué preparar y confirmar.

Al recuperar el foco, `checktime` detecta cambios externos sin descartar tus
ediciones locales. Mantén el agente fuera del terminal interno si usas `ZR`:
reiniciar Neovim termina sus terminales internos.

## Mantenimiento

- `:PluginsUpdate`: revisar actualizaciones; `:write` aplica y `:quit` cancela.
- `:PluginsRestore`: volver a las revisiones del lockfile.
- `:ToggleFormatter`: activar/desactivar formato al guardar para el buffer actual.
- `:GitLink`: copiar enlace GitHub de la línea o selección.
- `:CodeDiff install`: instalar/reparar la biblioteca nativa de diff.
- `:checkhealth`: diagnosticar herramientas y plugins.

Conform prioriza oxfmt solo en proyectos configurados para él; después prettierd
y prettier. Los formateadores de los otros lenguajes conservan el soporte previo.
No se fuerzan opciones de Prettier sobre las de cada proyecto.

## Cambios frente a la configuración anterior

Se reemplazaron Lazy, Telescope, Neo-tree, nvim-cmp y Avante por la base del artículo.
El perfil anterior de depuración, neotest, Flutter Tools, REST, base de datos y
mascota ya no se carga en este perfil orientado a revisión. La versión anterior
completa sigue disponible en el historial Git (`596ba60`) y en el respaldo local
creado antes de la migración. Los datos anteriores de plugins/Mason no se borraron.

`Tab` ahora cambia pestañas; antes cambiaba buffers. El chat se ejecuta en el agente
externo; Copilot sigue ofreciendo sugerencias inline.
Lazygit usa el preset remoto de Snacks compatible con Windows, sin comandos Fish.
UI2 y tiny-cmdline se activan únicamente en sesiones con interfaz.

## Validación

```powershell
nvim --headless -l tests/syntax.lua
nvim --headless -l tests/editor.lua
$env:NVIM_TEST = '1'
nvim --headless -c "lua dofile('tests/health.lua')" -c 'qa!'
Remove-Item Env:NVIM_TEST
```

`NVIM_TEST=1` desactiva las instalaciones automáticas de Mason/Treesitter durante
las pruebas; `NVIM_INSTALL=1` acepta instalar los plugins declarados para CI.
CI comprueba sintaxis, utilidades de contexto y arranque en Windows y Linux.

La prueba opcional de interfaz se ejecuta en terminal, con `NVIM_TEST=1`:
`nvim -c "lua dofile('tests/ui.lua')"`. Comprueba UI2, búsqueda, Oil y CodeDiff;
deja el resultado en `stdpath('cache')/27nvim-ui-test.log` y cierra esa sesión.
