-- Plain Neovim settings. The why lives next to each setting; SPEC.md has the overview.

local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

-- netrw off: `nvim .` opens the snacks explorer instead (see ui.lua)
g.loaded_netrw = 1

-- Make the terminal tab show the file name
opt.title = true

-- Look and feel ---------------------------------------------------------

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.mouse = "a"
opt.pumheight = 10
opt.pumblend = 10
opt.laststatus = 3 -- one global statusline
opt.winborder = "rounded"

-- 2-space indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Folds come from Treesitter (step 4); everything starts unfolded
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Search: case-insensitive until a capital letter is typed
opt.ignorecase = true
opt.smartcase = true

-- Snappier events and key sequences
opt.updatetime = 200
opt.timeoutlen = 300

-- Keep the command line visible; the statusline must not hide it
-- (deliberately kept from the old LazyVim config, differs from the article)
opt.cmdheight = 2

-- Undo survives closing the file; swapfiles only get in the way
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Make Mason-installed binaries resolvable (vtsls etc. spawn from here)
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- Yank and paste go through the system clipboard
opt.clipboard = "unnamedplus"

-- New splits open below and to the right
opt.splitbelow = true
opt.splitright = true

-- Diagnostics: underlined, sorted by severity, inline `● message`
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
  severity_sort = true,
})

-- Neovim 0.12 experimental message/commandline UI (ui2)
require("vim._core.ui2").enable()

-- Route vim.ui through snacks (checkhealth: input + select)
vim.ui.input = function(opts, on_confirm)
  Snacks.input(opts, on_confirm)
end
vim.ui.select = function(items, opts, on_choice)
  Snacks.picker.select(items, opts, on_choice)
end

-- Remote-plugin providers unused here; disabling silences checkhealth and
-- skips the provider searches at startup
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
