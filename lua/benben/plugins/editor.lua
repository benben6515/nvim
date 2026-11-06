-- Editor muscle memory carried over from LazyVim. Their keymaps live in
-- plugins/keymaps.lua; this file only sets the plugins up.

-- flash.nvim: s jump, S treesitter selection, R treesitter search
require("flash").setup({})

-- yanky.nvim: yank ring
require("yanky").setup({
  highlight = { timer = 200 },
  preserve_cursor_position = { enabled = true },
})

-- dial.nvim: smart increment. Needs no setup; <C-a>/<C-x> go to it (so no
-- select-all on <C-a>).

-- mini.ai: treesitter-aware text objects
require("mini.ai").setup({
  n_lines = 500,
  custom_textobjects = {
    o = require("mini.ai").gen_spec.treesitter({ -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
    c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
    d = { "%f[%d]%d+" }, -- digits
    e = { -- word with case
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    g = function() -- whole buffer
      local from = { line = 1, col = 1 }
      local to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) }
      return { from = from, to = to }
    end,
    u = require("mini.ai").gen_spec.function_call(), -- u for "Usage"
    U = require("mini.ai").gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot
  },
})
