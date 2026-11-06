-- Core keymaps that need no plugin. Plugin keymaps live in plugins/keymaps.lua.

local map = vim.keymap.set

-- Delete without copying (the yanked text stays safe)
map({ "n", "v" }, "x", '"_x')

-- Open a line below/above without continuing a comment (o<Esc>^Da)
map("n", "<leader>o", "o<Esc>^Da", { remap = true, desc = "Open line below" })
map("n", "<leader>O", "O<Esc>^Da", { remap = true, desc = "Open line above" })

-- Home-row window control
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })

-- Tabs
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
