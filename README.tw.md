[ [English](README.md) | [繁體中文](README.tw.md) ]

# benben 的 Neovim 設定

一套從零打造的 Neovim 設定，專為 agentic coding 而生，完全建立在
**Neovim 0.12 內建功能**上：用
[`vim.pack`](https://neovim.io/doc/user/pack.html) 管理外掛、`vim.lsp.enable` +
`after/lsp/<name>.lua` 設定 LSP、`ui2` 處理訊息，並把 `:restart` 映射到 `ZR`，
可保留 session 重新載入。

整個設定由 AI agent 依照一份以平實英文撰寫的 spec 打造——做法出自
Takuya Matsuyama（devaslife）的
[Effective Neovim setup for agentic coding towards 2027][article]。
**[SPEC.md](SPEC.md)** 是唯一的 source of truth：逐步說明做什麼、為什麼，
包括所有從我前一個 LazyVim 設定延續過來的內容。

[article]: https://www.devas.life/effective-neovim-setup-for-agentic-coding-towards-2027/

## 原則

- **不裝任何 AI 外掛。** Agent 在終端機裡跑（Claude Code / OpenCode）；
  Neovim 只用來檢視與編輯它們產出的內容。唯一和 AI 相關的功能只有兩個小幫手：
  `<leader>yf` / `<leader>yp` 複製 `path#L12` 格式的參照，方便貼進 agent 的 prompt。
- **LazyVim 的肌肉記憶全部保留。** `<leader>` 開頭的 keymap、`gd`/`gr`、
  `<C-hjkl>` 視窗切換、`<S-h>`/`<S-l>` buffer 切換、which-key、flash、yanky、
  dial、trouble、bufferline——全部延續下來。
- **版本自由浮動。** 不鎖版本；用 `vim.pack.update()` 更新。

## 目錄結構

```
init.lua                  vim.loader + 依序 require
lua/benben/config/        純設定：options、keymaps、autocmds、commands
lua/benben/plugins/       vim.pack.add + 每種關注點一個檔案
lua/benben/colors/        「benben」——我自己的霓虹賽博龐克配色
lua/benben/utils.lua      root() 輔助函式（向上搜尋 marker）
colors/benben.lua         shim，讓 :colorscheme benben 能正確解析
after/lsp/                各 server 的設定，0.12 會自動合併
SPEC.md                   這份設定所實作的 spec
```

## 環境需求

Neovim 0.12+、Nerd Font、`git`、`tree-sitter` CLI + C 編譯器（parser 在本地
編譯）、`node`（Mason 用）、`rg`/`fd`（picker 用）、`lazygit`（浮動視窗，
`<leader>gg`）。

## 從其他設定遷移

替換 `~/.config/nvim` 或 `~/.local/share/nvim` **之前，先把所有執行中的
nvim 全部關掉**（逐一 `:qa!`，保險起見再 `pkill nvim`）。執行中的 nvim 把
舊設定和外掛留在記憶體裡；一旦那些路徑被搬走，它就會整個卡死——按鍵無反應、
連 `:qa!` 都叫不動，只能把該終端機砍掉。首次啟動若 parser 編譯失敗（缺
`tree-sitter` CLI），裝好（`brew install tree-sitter-cli`）再重開 nvim 即可；
blink.cmp 的 native fuzzy library 在鎖定的 stable tag 上會於首次啟動自動下載。

## 重點特色

- 10 套 colorscheme（預設 `dracula-soft`）+ 透明背景 + 按 `<leader>uC` 開啟
  colorscheme 選擇器
- LSP 涵蓋 TS/JS、Vue、Tailwind、Python、Lua、Markdown、JSON、TOML；blink.cmp
  補全；conform 存檔自動格式化（web 系走 oxfmt → prettierd → prettier，其他用
  stylua/shfmt/sqlfluff/taplo），每個 buffer 可用 `:ToggleFormatter` 開關
- Review-first 的 git 工具鏈：gitsigns（`<leader>gb` blame、`]h`/`[h` 跳 hunk）、
  mini.diff overlay（`<leader>gd`）、lazygit 浮動視窗（`<leader>gg`），還有
  `<leader>go` 用最後碰過這一行的 commit 版本開啟檔案
