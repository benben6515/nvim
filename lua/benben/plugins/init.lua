-- Plugins: every plugin is installed in the single vim.pack.add call below.
-- Group files only configure them; keymaps that need a plugin live in keymaps.lua
-- (required last, so all plugins are set up first).

vim.pack.add({
  -- theme
  { src = "https://github.com/xiyaowong/transparent.nvim" },
  { src = "https://github.com/sainnhe/everforest" },
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/sainnhe/sonokai" },
  { src = "https://github.com/Mofiqul/dracula.nvim" },
  { src = "https://github.com/craftzdog/solarized-osaka.nvim" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/tjdevries/colorbuddy.nvim" },
  { src = "https://github.com/2nthony/vitesse.nvim" },

  -- ui
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/sphamba/smear-cursor.nvim" },

  -- editor
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/gbprod/yanky.nvim" },
  { src = "https://github.com/monaqa/dial.nvim" },
  { src = "https://github.com/nvim-mini/mini.ai" },

  -- coding
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/Saghen/blink.cmp" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/smjonas/inc-rename.nvim" },

  -- git
})

-- Group files, in load order:
require("benben.plugins.theme")
require("benben.plugins.ui")
require("benben.plugins.editor")
require("benben.plugins.coding")
require("benben.plugins.keymaps")
