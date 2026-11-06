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

-- LSP: servers are enabled in coding.lua; keymaps attach per buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("benben_lsp_keymaps", { clear = true }),
  callback = function(args)
    local function bmap(mode, lhs, rhs, desc)
      local opts = type(desc) == "table" and desc or { desc = desc }
      opts.buffer = args.buf
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- jumps go through the picker
    bmap("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, "Goto Definition")
    bmap("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    bmap("n", "gr", function()
      Snacks.picker.lsp_references()
    end, "References")
    bmap("n", "gI", function()
      Snacks.picker.lsp_implementations()
    end, "Goto Implementation")
    bmap("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Goto Type Definition")

    bmap("n", "K", vim.lsp.buf.hover, "Hover")
    bmap("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
    bmap("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    bmap("n", "]d", function()
      vim.diagnostic.jump({ count = vim.v.count1, float = true })
    end, "Next Diagnostic")
    bmap("n", "[d", function()
      vim.diagnostic.jump({ count = -vim.v.count1, float = true })
    end, "Prev Diagnostic")
    bmap("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

    bmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    bmap("n", "<leader>cf", function()
      require("conform").format({ bufnr = args.buf, async = true, lsp_format = "fallback" })
    end, "Format")
    bmap("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
    bmap("n", "<leader>cr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename (live preview)" })
  end,
})

-- inlay hints: off by default, one key to flip
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- flash: jump and treesitter search
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
map({ "n", "o", "x" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<C-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })

-- dial: smart increment, sequential with g prefix
map("n", "<C-a>", function()
  return require("dial.map").inc_normal("augment")
end, { expr = true, desc = "Increment" })
map("n", "<C-x>", function()
  return require("dial.map").dec_normal("augment")
end, { expr = true, desc = "Decrement" })
map("n", "g<C-a>", function()
  return require("dial.map").inc_gnormal("augment")
end, { expr = true, desc = "Increment (sequential)" })
map("n", "g<C-x>", function()
  return require("dial.map").dec_gnormal("augment")
end, { expr = true, desc = "Decrement (sequential)" })
map("v", "<C-a>", function()
  return require("dial.map").inc_visual("augment")
end, { expr = true, desc = "Increment" })
map("v", "<C-x>", function()
  return require("dial.map").dec_visual("augment")
end, { expr = true, desc = "Decrement" })
map("v", "g<C-a>", function()
  return require("dial.map").inc_gvisual("augment")
end, { expr = true, desc = "Increment (sequential)" })
map("v", "g<C-x>", function()
  return require("dial.map").dec_gvisual("augment")
end, { expr = true, desc = "Decrement (sequential)" })
