-- Icons: one source for every plugin (mini.icons mocks nvim-web-devicons)
require("mini.icons").setup({})
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

-- Taiwan time (UTC+8), independent of the machine's timezone
local function tw_hour()
  return os.date("!*t", os.time() + 8 * 3600).hour
end

-- stylua: ignore
local greeting_pools = {
  late_night = { -- 0-4
    "It's the middle of the night. Even Neovim is idle.",
    "Real lazy devs let the LSP do the night shift.",
    "Still up? Your bed called. It misses you.",
    "The quickest fix is sleep. Debug tomorrow.",
  },
  morning = { -- 5-10
    "Morning. Let's coast through it, lazy style.",
    "Good morning. Do less, but better.",
    "Slow start is still a start. Hi.",
    "Lazy morning, efficient afternoon. Maybe.",
    "Coffee's brewing, plugins are lazy-loading.",
  },
  noon = { -- 11-13
    "Lazy lunch first. The code can wait.",
    "Nap now, merge later. It's noon.",
    "Good noon. Delegate the boring parts.",
    "Half-day of rest, half-day of genius.",
  },
  afternoon = { -- 14-17
    "Good afternoon. Autocompletion exists for a reason.",
    "Work smart, nap hard. Afternoon vibes.",
    "Slow is smooth. Smooth is lazy.",
    "Hydrate, delegate, autocomplete.",
  },
  evening = { -- 18-21
    "Good evening. Let tomorrow's you handle it.",
    "Wind down. Even lazy people ship things.",
    "Evening: the golden hour of doing nothing.",
    "Good evening. Save, commit, rest.",
  },
  night = { -- 22-23
    "Almost midnight. Take it easy on yourself.",
    "Bed > buffers. You know it's true.",
    "Lazy rule #1: never debug past midnight.",
    "One more line, then actually sleep. Promise.",
  },
}

local function greeting(h)
  math.randomseed() -- OS entropy
  local pool = h < 5 and greeting_pools.late_night
    or h < 11 and greeting_pools.morning
    or h < 14 and greeting_pools.noon
    or h < 18 and greeting_pools.afternoon
    or h < 22 and greeting_pools.evening
    or greeting_pools.night
  return "[ " .. pool[math.random(#pool)] .. " ]"
end

local header_logo = (function()
  local logo = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
  local lines = vim.split(logo:gsub("^%s+", ""):gsub("\n%s+", "\n"):gsub("%s+$", ""), "\n", { plain = true })
  local width = math.max(unpack(vim.tbl_map(vim.api.nvim_strwidth, lines)))
  for i, line in ipairs(lines) do
    lines[i] = line .. (" "):rep(width - vim.api.nvim_strwidth(line))
  end
  return table.concat(lines, "\n")
end)()

-- Dashboard greeting keeps its highlight through colorscheme switches
local function set_greeting_hl()
  vim.api.nvim_set_hl(0, "SnacksDashboardGreeting", { link = "String", default = true })
end
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("benben_dashboard_greeting_hl", { clear = true }),
  callback = set_greeting_hl,
})
set_greeting_hl()

-- snacks.nvim: statusline, notifier, indent guides, scope, words, input,
-- terminal, dashboard. picker/explorer joined in step 3, lazygit in step 6.
require("snacks").setup({
  statusline = { enabled = true },
  notifier = { enabled = true },
  indent = { enabled = true },
  scope = { enabled = true },
  words = { enabled = true }, -- needs LSP (step 5)
  input = { enabled = true },
  terminal = { enabled = true },
  statuscolumn = { enabled = true },
  lazygit = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = { layout = { layout = { width = 32, min_width = 32 } } },
    },
  },
  dashboard = {
    preset = {
      header = header_logo,
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { header = header_logo, padding = 1 },
      function()
        return {
          { text = { greeting(tw_hour()), hl = "SnacksDashboardGreeting" }, align = "center", padding = 1 },
        }
      end,
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    },
  },
})

-- bufferline.nvim: <S-h>/<S-l> cycling, pins, close left/right
require("bufferline").setup({
  options = {
    close_command = function(n)
      Snacks.bufdelete(n)
    end,
    right_mouse_command = function(n)
      Snacks.bufdelete(n)
    end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diag)
      local ret = (diag.error and " " .. diag.error .. " " or "") .. (diag.warning and " " .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      { filetype = "snacks_layout_box" }, -- snacks explorer sidebar
    },
  },
})

-- which-key.nvim: discoverability for the <leader> tree
require("which-key").setup({
  spec = {
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>u", group = "ui" },
    { "<leader>w", group = "windows" },
    { "<leader><tab>", group = "tab" },
  },
})

-- smear-cursor.nvim: cursor smear between buffers, lines and in insert mode
require("smear_cursor").setup({
  smear_between_buffers = true,
  smear_between_neighbor_lines = true,
  scroll_buffer_space = true,
  legacy_computing_symbols_support = false,
  smear_insert_mode = true,
})
