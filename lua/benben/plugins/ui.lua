-- Icons: one source for every plugin (mini.icons mocks nvim-web-devicons)
require("mini.icons").setup({})
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

-- snacks.nvim: statusline, notifier, indent guides, scope, words, input,
-- terminal. picker/explorer, lazygit also on. No dashboard — vanilla nvim
-- intro screen is fine.
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
  scroll = { enabled = true }, -- smooth scroll, kept from the LazyVim days
  bigfile = { enabled = true }, -- heavy features off in huge files
  quickfile = { enabled = true }, -- render files while still loading
  picker = {
    enabled = true,
    sources = {
      explorer = {
        layout = { layout = { width = 32, min_width = 32 } },
        on_show = function(picker)
          -- after `nvim ./some/dir` the main window only holds the empty
          -- buffer left by the deleted dir arg: close it so the explorer
          -- takes the full frame. A real file in main is left untouched.
          local main = picker.main
          local b = main and vim.api.nvim_win_is_valid(main) and vim.api.nvim_win_get_buf(main)
          if b
            and vim.bo[b].buftype == ""
            and vim.api.nvim_buf_get_name(b) == ""
            and not vim.bo[b].modified then
            pcall(vim.api.nvim_win_close, main, false)
            pcall(vim.api.nvim_buf_delete, b, { force = true })
          end
          -- the list buffer is unnamed, so the statusline renders it as
          -- [Scratch]; name it
          local list = picker.list and picker.list.win
          if list and list:valid() then
            local lb = list.buf
            if lb and vim.api.nvim_buf_get_name(lb) == "" then
              pcall(vim.api.nvim_buf_set_name, lb, "Explorer")
            end
          end
          -- closing main may drop keyboard focus outside the picker
          picker:focus("input")
        end,
      },
    },
  },
})

-- netrw is off: opening a directory (`nvim .`, `:e some/dir`) swaps to the
-- snacks explorer. VimEnter/UIEnter do NOT fire for directory args, so this
-- hooks the one event that does.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("benben_explorer_dir", { clear = true }),
  callback = function(args)
    local name = args.file
    if name == "" or vim.fn.isdirectory(name) ~= 1 then
      return
    end
    -- guard against re-processing (the explorer itself enters BufEnter too)
    if vim.b[args.buf].benben_dir_handled or vim.bo[args.buf].filetype == "snacks_picker_list" then
      return
    end
    vim.b[args.buf].benben_dir_handled = true
    vim.cmd.cd(name)
    Snacks.explorer.open()
    -- the explorer's on_show closes the leftover empty window
    vim.schedule(function()
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end)
  end,
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
