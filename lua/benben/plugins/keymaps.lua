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
