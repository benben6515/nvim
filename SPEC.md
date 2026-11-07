# SPEC — benben's Neovim setup

A from-scratch Neovim config for agentic coding, built on Neovim 0.12 built-ins.
Inspired by [Effective Neovim setup for agentic coding towards 2027](https://www.devas.life/effective-neovim-setup-for-agentic-coding-towards-2027/)
by Takuya Matsuyama (devaslife).

This spec describes **what** and **why**. The Lua is just implementation —
agents (and future me) should read this file first.

## Principles

- **Neovim 0.12 built-ins over plugins**: `vim.pack` (plugin manager),
  `vim.lsp.enable` + `after/lsp/<name>.lua` (LSP), `ui2` (message UI), `:restart`
  (reload + session restore). Requires Neovim 0.12+.
- **No AI plugins.** Agentic coding happens in a terminal (Claude Code / OpenCode);
  Neovim is where I *review and edit* what agents produce. The only AI-related
  features are tiny "pass context to the agent" helpers (step 7).
- **Versions flow.** No pinning, no lock file (`nvim-pack-lock.json` is ignored).
  Updating = `vim.pack.update()` inside Neovim.
- **LazyVim muscle memory stays.** Keymap conventions follow LazyVim:
  `<leader>`-prefixed, `gd`/`gr`/`gI`/`gy`, `K`, `<C-hjkl>` windows,
  `<S-h>`/`<S-l>` buffers. Nothing here re-teaches my fingers.
- **Minimal core, grows on demand.** Language support matches what I actually
  work in: TS/JS/TSX, Vue, Tailwind, Python, SQL, Lua, Markdown, shell, TOML/JSON.
- Every step is verified with `nvim --headless +qa` and committed separately.

## 0. Prerequisites

- Neovim 0.12+ (built with the built-ins above in mind)
- `tree-sitter` CLI + C compiler on PATH — *nvim-treesitter* main branch
  compiles parsers locally
- `rg`, `fd`, `lazygit`, `node` — back the picker, lazygit float, Mason
- Config folder is a git repo, branch `main`
- `.gitignore` lists `nvim-pack-lock.json` (versions flow) and local junk
- `stylua.toml` kept from the previous config: spaces, width 120

## 1. Foundation

- Layout, namespace `benben`:
  - `init.lua`: enables `vim.loader`, then requires, in order:
    1. `benben.config.options`
    2. `benben.config.keymaps`
    3. `benben.config.autocmds`
    4. `benben.config.commands`
    5. `benben.plugins`
  - `lua/benben/config/`: plain Neovim settings, one file per concern
  - `lua/benben/plugins/`: `init.lua` installs every plugin in one `vim.pack.add`
    call, then requires each group file (`theme`, `ui`, `editor`, `coding`, `git`,
    `keymaps`). Group files hold no non-plugin settings.
  - `colors/benben.lua`: shim for the local colorscheme in `lua/benben/colors/`
  - `after/lsp/<name>.lua`: per-server settings, auto-merged by 0.12 (no boilerplate)
- Options:
  - Leader and local leader are **Space**; clipboard `unnamedplus`
  - Hybrid line numbers, `cursorline`, no wrap, `scrolloff` 10, `sidescrolloff` 8
  - `signcolumn` always on; `title` on; `termguicolors`
  - 2-space indent, `expandtab`, `smartindent`
  - `ignorecase` + `smartcase`; `updatetime` 200, `timeoutlen` 300
  - `cmdheight` 2 (kept from the old config: the statusline must not hide the
    command line — deliberately different from the article's 0)
  - `winborder` rounded, `pumheight` 10, `pumblend` 10, global statusline
    (`laststatus` 3), mouse on
  - Persistent undo in `~/.local/share/nvim/undodir`
  - Diagnostics: underlined, not updated while typing, sorted by severity,
    inline `● message` (source shown only when several)
  - `ui2` enabled (experimental): `require("vim._core.ui2").enable()`
- Core keymaps (LazyVim conventions + hand-picked article ideas):
  - `x` deletes without copying
  - `<leader>o` / `<leader>O` open a line without continuing a comment
  - `<C-h/j/k/l>` move between windows; `<leader>-` split below, `<leader>|` right
  - `<leader>bd` deletes the buffer (via snacks)
  - `<leader><tab>n` / `<leader><tab>d` new / close tab
  - `jk` is deliberately *not* mapped (never was)

## 2. Look

- **Colorschemes** — 10 of them, ported from the old config; switch freely:
  dracula (default active: `dracula-soft`), everforest, catppuccin, tokyonight,
  sonokai, solarized-osaka, nightfox, vitesse (+ colorbuddy), and `benben` —
  a local neon-cyberpunk theme I wrote.
- **transparent.nvim**: backgrounds clear so the terminal's blur shows through.
  Toggle with `<leader>ut`.
- **Legibility overrides** for WinSeparator/LineNr/etc. re-applied after every
  colorscheme switch back to dracula/catppuccin (they set near-invisible greys).
- **snacks.nvim** provides: statusline, notifier, indent guides, scope, words
  (needs LSP, works from step 5), input, terminal, and the dashboard
  (custom ASCII header + Taiwan-time greeting pool, ported from the old config).
- **bufferline.nvim** with `<S-h>`/`<S-l>`, `[b`/`]b`, `[B`/`]B`, pin and
  close-left/right keys — closes go through `Snacks.bufdelete`.
- **which-key.nvim** for discoverability.
- **smear-cursor.nvim** because I like the cursor smear.

## 3. Navigating & editor muscle memory

- Picker: **snacks.picker**.

| Keys | Action |
| --- | --- |
| `<leader><space>` | Smart find files |
| `<leader>,` | Buffers |
| `<leader>/` | Live grep (root) |
| `<leader>:` | Command history |
| `<leader>ff` / `<leader>fF` | Find files (root / cwd) |
| `<leader>fr` / `<leader>fR` | Recent files (cwd / all) |
| `<leader>fw` / `<leader>fW` | Grep word (root / cwd) |
| `<leader>sw` | Grep selection (visual) |
| `<leader>e` / `<leader>fe` | File explorer (root / cwd) |
| `<leader>uC` | Colorscheme picker |
| `<leader>n` / `<leader>un` | Notification history / dismiss all |

- File explorer: **snacks.explorer** (sidebar, width 32) — already my picker of
  choice in LazyVim; oil.nvim can wait until I actually miss it.
- **netrw is off** (`vim.g.loaded_netrw`): opening nvim with a directory
  (`nvim .`) or `:e some/dir` swaps straight into the explorer sidebar.
  Gotcha recorded the hard way: with netrw disabled, directory-arg startups
  fire **no VimEnter/UIEnter** — the swap hooks `BufEnter` (the only event
  that fires) and deletes the raw directory buffer after opening the sidebar.
- **flash.nvim** (`s` jump, `S` treesitter, `R` search, `<C-s>` in cmdline)
- **trouble.nvim**: `<leader>xx` / `<leader>xX` diagnostics, `<leader>cs` symbols,
  `<leader>cS` LSP, `[q` / `]q` quickfix
- **yanky.nvim**: `<p>` / `<P>` put with yank ring, `[y` / `]y` cycle
- **dial.nvim**: `<C-a>` / `<C-x>` (and `g`-prefixed) smart increment
- **mini.ai**: treesitter-aware text objects (`f` function, `c` class, `o` block...)

## 4. Syntax

- **nvim-treesitter**, main branch. Parsers (installed via the FileType hook and
  the plugin's `install()`): bash, css, diff, gitignore, html, javascript,
  jsdoc, json, lua, luadoc, luap, markdown, markdown_inline, python, query,
  regex, sql, toml, tsx, typescript, vim, vimdoc, vue, yaml
  (jsonc/scss have no parser on the main branch; css/json cover them)
- A FileType autocmd starts Treesitter highlight and Treesitter folds
  (`foldmethod=expr`, `foldlevel` 99 — everything starts unfolded)
- `:TSUpdate` runs on the `PackChanged` event, so parsers stay in sync

## 5. Code smarts

- **Mason** + **mason-tool-installer**: install on start, never auto-update.
  - Servers: lua-language-server, vtsls, eslint-lsp, tailwindcss-language-server,
    vue-language-server, pyright, marksman, json-lsp, taplo
  - Formatters: prettierd, oxfmt, stylua, shfmt, sqlfluff
- **nvim-lspconfig** supplies defaults; servers turn on with `vim.lsp.enable`:
  lua_ls, vtsls, eslint, tailwindcss, vue_ls, pyright, marksman, jsonls, taplo
- Per-server settings in `after/lsp/`:
  - **vtsls**: workspace TypeScript SDK, imports updated on file move, short
    inlay hints (no variable/parameter types)
  - **lua_ls**: LuaJIT runtime, `checkThirdParty` off (lazydev supplies the libs),
    silences missing-fields
- **lazydev.nvim**: completions for the Neovim API + the `vim.uv` library while
  editing this config
- **blink.cmp**: `enter` preset (Enter accepts), docs after 200 ms, auto-brackets
  after functions, cmdline completion for `:` only, ghost text off (nothing to
  clash with — no AI completions)
- **conform.nvim** formats on save (1000 ms timeout, LSP fallback):

| Filetypes | Formatter (first available) |
| --- | --- |
| js, ts, jsx, tsx, json, css, scss, html, markdown, yaml | oxfmt → prettierd → prettier |
| lua | stylua |
| sh | shfmt |
| sql | sqlfluff |
| toml | taplo |

  - oxfmt only runs when the project has an oxfmt config or a `vite.config.ts`
  - `:ToggleFormatter` turns format-on-save off/on for the current buffer
- **mini.pairs** (insert + command mode; upstream opts — LazyVim's extra skip
  rules were LazyVim-internal, not mini.pairs features)
- **ts-comments.nvim** for TSX/Vue comment strings
- **inc-rename.nvim**: `<leader>cr` shows a live preview while renaming
- LSP keymaps on attach: `gd` `gD` `gr` `gI` `gy` (through the picker where
  sensible), `K` hover, `gK` / `<C-k>` signature, `]d` / `[d` diagnostics,
  `<leader>ca` actions, `<leader>cf` format, `<leader>cl` info,
  `<leader>uh` inlay hints toggle

## 6. Git

This is the part I use most when reviewing agent-produced code.

- **gitsigns.nvim**:

| Keys | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gb` | Blame the line |
| `<leader>gp` | Preview the hunk |
| `<leader>gh` | Stage / unstage the hunk |
| `<leader>gs` | Stage / unstage the buffer |
| `<leader>go` | Open the file as of the commit that last touched the line |

- **mini.diff** overlay (upstream, not a fork):

| Keys | Action |
| --- | --- |
| `<leader>gd` | Toggle the overlay |
| `]c` / `[c` | Jump between hunks |

- **lazygit** in a float through snacks: `<leader>gg` (root), `<leader>gG` (cwd)

## 7. Agentic helpers

Small ways to hand context from Neovim to a terminal agent.

| Keys | Action |
| --- | --- |
| `<leader>yf` | Copy the file path relative to cwd with `#L<line>` (visual: `#L<start>-L<end>`) |
| `<leader>yp` | Same, absolute path |

Both show a notification with the copied text — paste it into Claude Code /
OpenCode and the agent lands on the exact line.

- Markdown spell stays off (FileType autocmd) — carried over as a crash guard
  from the old config
- `ZR` maps to `:restart` — Neovim reloads itself and restores the session.
  The agent works in a separate terminal, never inside `:terminal`.

## 8. Ship

- README credits the article and the decisions above
- Verification checklist:
  1. `nvim --headless +qa` exits 0
  2. LSP attaches in TS/Vue/Python/Lua buffers; format-on-save works
  3. Picker, grep, explorer, lazygit float work
  4. `dracula-soft` loads; switching colorschemes works
  5. Startup < 100 ms
  6. Published as https://github.com/benben6515/nvim

## Notes from the build

Facts discovered while implementing (kept here so future agents don't re-learn them):

- **blink.cmp v2** needs the companion library `saghen/blink.lib` installed
  alongside `saghen/blink.cmp`.
- **nvim-treesitter main branch** has no `jsonc`/`scss` parsers (css/json cover
  them); parsers install through `require("nvim-treesitter").install()` —
  Neovim 0.12 has no built-in `vim.treesitter.language.install`.
- The Vue server is **`vue_ls`** in current nvim-lspconfig (not `vuels`).
- Mason's PATH prepend is not reliable at startup, so `config/options.lua`
  prepends `stdpath("data")/mason/bin` itself.
- **Treesitter queries are symlinks.** nvim-treesitter main ships queries in
  its own `runtime/queries/` and links them into `stdpath("data")/site/queries`.
  The links survive parser installs but pointed at the old lazy.nvim path once
  — after moving plugin managers, re-link `site/queries/<lang>` to the new
  plugin's `runtime/queries/<lang>` or every non-bundled language silently
  loses syntax highlighting while `vim.treesitter.start` still "works".
- blink.cmp ships a Lua fuzzy fallback; build the native matcher once with
  `require("blink.cmp").build():pwait()` (done; `:checkhealth blink.cmp` confirms).
- **Headless quirk:** calling `conform.format()` synchronously from a `+lua`
  command-line argument under `--headless` deadlocks (event-loop context).
  Interactive use and `:w` (format-on-save) are unaffected — verified both.
- Group files configure plugins imperatively (`require(...).setup({...})`).
  There is no plugin spec interpreter: if a plugin is added to `vim.pack.add`,
  its group file must also be required from `plugins/init.lua` (a missing
  require fails silently — this bit once).

