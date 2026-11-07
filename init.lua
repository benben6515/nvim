-- benben's Neovim config — Neovim 0.12+, no distribution, see SPEC.md
vim.g.benben_t0 = vim.uv.hrtime() -- dashboard shows config load time from here
vim.loader.enable()

require("benben.config.options")
require("benben.config.keymaps")
require("benben.config.autocmds")
require("benben.config.commands")
require("benben.plugins")
