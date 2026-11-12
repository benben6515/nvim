[ [English](README.md) | [繁體中文](README.tw.md) ]

# benben's Neovim config

A from-scratch Neovim setup for agentic coding, built on **Neovim 0.12 built-ins**:
[`vim.pack`](https://neovim.io/doc/user/pack.html) for plugins, `vim.lsp.enable` +
`after/lsp/<name>.lua` for LSP, `ui2` for messages, `:restart` (mapped to `ZR`)
to reload with the session restored.

Built with an AI agent following a spec written in plain English — the approach
from [Effective Neovim setup for agentic coding towards 2027][article] by
Takuya Matsuyama (devaslife). **[SPEC.md](SPEC.md)** is the source of truth:
it describes what and why, step by step, including everything carried over
from my previous LazyVim config.

[article]: https://www.devas.life/effective-neovim-setup-for-agentic-coding-towards-2027/

## Principles

- **No AI plugins.** Agents run in a terminal (Claude Code / OpenCode); Neovim
  is for reviewing and editing what they produce. The only AI-related features
  are tiny helpers: `<leader>yf` / `<leader>yp` copy `path#L12` references to
  paste into an agent's prompt.
- **LazyVim muscle memory stays.** `<leader>`-prefixed keymaps, `gd`/`gr`,
  `<C-hjkl>` windows, `<S-h>`/`<S-l>` buffers, which-key, flash, yanky, dial,
  trouble, bufferline — all carried over.
- **Versions flow.** No pinning; update with `vim.pack.update()`.

## Layout

```
init.lua                  vim.loader + requires, in order
lua/benben/config/        plain settings: options, keymaps, autocmds, commands
lua/benben/plugins/       vim.pack.add + one group file per concern
lua/benben/colors/        "benben" — my own neon-cyberpunk colorscheme
lua/benben/utils.lua      root() helper (marker search upward)
colors/benben.lua         shim so :colorscheme benben resolves
after/lsp/                per-server settings, auto-merged by 0.12
SPEC.md                   the spec this config implements
```

## Requirements

Neovim 0.12+, a Nerd Font, `git`, `tree-sitter` CLI + C compiler (parsers
compile locally), `node` (Mason), `rg`/`fd` (picker), `lazygit` (float at
`<leader>gg`).

## Migrating from another config

Quit **every running nvim instance before swapping** `~/.config/nvim` or
`~/.local/share/nvim` (`:qa!` everywhere, then `pkill nvim` to be sure). A
running nvim keeps its old config and plugins in memory; once their paths
move out from under it, it wedges — keys stop responding and even `:qa!`
won't answer, so the only way out is killing its terminal. If parsers fail
to compile on first start (`tree-sitter` CLI missing), install it
(`brew install tree-sitter-cli`) and start nvim again; blink.cmp's native
fuzzy lib builds itself on first start from the pinned stable tag.

## Highlights

- 10 colorschemes (default `dracula-soft`) + transparent backgrounds + a
  colorscheme picker at `<leader>uC`
- LSP for TS/JS, Vue, Tailwind, Python, Lua, Markdown, JSON, TOML; blink.cmp
  completion; conform format-on-save (oxfmt → prettierd → prettier for the web
  family, stylua/shfmt/sqlfluff/taplo elsewhere), `:ToggleFormatter` per buffer
- Review-first git stack: gitsigns (`<leader>gb` blame, `]h`/`[h` hunks),
  mini.diff overlay (`<leader>gd`), lazygit float (`<leader>gg`), and
  `<leader>go` to open the file as of the commit that last touched the line
