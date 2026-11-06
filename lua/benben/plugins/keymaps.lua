-- Keymaps that need a plugin. Required last: every plugin is set up by then.
-- Group files hold no keymaps, per SPEC.md.

local map = vim.keymap.set
local root = require("benben.utils").root

-- bufferline: cycle, move, pin, close sides
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
map("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })
map("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
map("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
map("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
map("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })

-- snacks: delete a buffer without wrecking the window layout
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- snacks: notifications
map("n", "<leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification History" })
map("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })

-- snacks terminal: floats over the current work
map("n", "<C-/>", function()
  Snacks.terminal(nil, { cwd = root() })
end, { desc = "Toggle Terminal (root)" })
map("n", "<C-_>", function()
  Snacks.terminal(nil, { cwd = root() })
end, { desc = "which_key needs C-/" })
map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = vim.uv.cwd() })
end, { desc = "Terminal (cwd)" })

-- transparent.nvim: toggle the see-through background
map("n", "<leader>ut", "<cmd>TransparentToggle<cr>", { desc = "Toggle Transparent Background" })

-- snacks picker: finding, grepping, exploring
map("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>,", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Grep (root)" })
map("n", "<leader>:", function()
  Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>e", function()
  Snacks.explorer({ cwd = root() })
end, { desc = "Explorer (root)" })
map("n", "<leader>fe", function()
  Snacks.explorer()
end, { desc = "Explorer (cwd)" })
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find Files (root)" })
map("n", "<leader>fF", function()
  Snacks.picker.files({ cwd = vim.uv.cwd() })
end, { desc = "Find Files (cwd)" })
map("n", "<leader>fr", function()
  Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent (cwd)" })
map("n", "<leader>fR", function()
  Snacks.picker.recent()
end, { desc = "Recent" })
map("n", "<leader>fw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep word (root)" })
map({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep selection/word" })
map("n", "<leader>fW", function()
  Snacks.picker.grep_word({ cwd = vim.uv.cwd() })
end, { desc = "Grep word (cwd)" })
map("n", "<leader>uC", function()
  Snacks.picker.colorschemes()
end, { desc = "Colorscheme Picker" })

-- trouble: diagnostics and symbols
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
map("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Previous Trouble/Quickfix Item" })
map("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next Trouble/Quickfix Item" })

-- yanky: put with yank ring, cycle the ring
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "=p", "<Plug>(YankyPutAfterFilter)")
map({ "n", "x" }, "=P", "<Plug>(YankyPutBeforeFilter)")
map({ "n", "x" }, "]y", "<Plug>(YankyCycleForward)")
map({ "n", "x" }, "[y", "<Plug>(YankyCycleBackward)")
