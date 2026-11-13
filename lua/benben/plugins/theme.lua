-- Colorschemes: 10 of them, switch freely. Default: everforest.

-- Theme-agnostic italics/styles (read when the colorscheme loads)
vim.g.everforest_enable_italic = true
vim.g.sonokai_enable_italic = true
vim.g.sonokai_style = "atlantis"
vim.g.sonokai_better_performance = 1

-- Transparent background: the terminal's blur shows through
require("transparent").setup({
  groups = {
    "Normal",
    "NormalNC",
    "Comment",
    "Constant",
    "Special",
    "Identifier",
    "Statement",
    "PreProc",
    "Type",
    "Underlined",
    "Todo",
    "String",
    "Function",
    "Conditional",
    "Repeat",
    "Operator",
    "Structure",
    "LineNr",
    "NonText",
    "SignColumn",
    "CursorLine",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
    "EndOfBuffer",
  },
  extra_groups = { "NormalFloat", "NvimTreeNormal" },
  exclude_groups = {},
})
require("transparent").clear_prefix("BufferLine")
require("transparent").clear_prefix("NeoTree")
require("transparent").clear_prefix("RenderMarkdown")

-- Local theme: neon cyberpunk I wrote — loads via :colorscheme benben
-- (colors/benben.lua shim); not loaded at startup since everforest is default
vim.cmd.colorscheme("everforest")

-- Brighten dim UI lines: dracula/catppuccin pick near-invisible greys on the
-- transparent near-black terminal bg
local overrides = {
  WinSeparator = { fg = "#7f849c" },
  VertSplit = { fg = "#7f849c" },
  LineNr = { fg = "#6c7086" },
  FoldColumn = { fg = "#6c7086" },
  EndOfBuffer = { fg = "#45475a" },
  -- SnacksPickerPathIgnored / GitStatusIgnored fall back to NonText;
  -- dracula-soft's #3B4048 is near-invisible (~1.4:1) on the dark bg
  NonText = { fg = "#6272a4" },
  SnacksPickerPathHidden = { fg = "#565f89" },
  SnacksPickerGitStatusIgnored = { fg = "#6272a4" },
}

local function apply_overrides()
  for group, opts in pairs(overrides) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

apply_overrides()

-- Re-apply after any :colorscheme switch back to these themes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "catppuccin", "dracula-soft" },
  callback = apply_overrides,
})
