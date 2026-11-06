return {
  -- flash.nvim: s jump, S treesitter selection, R treesitter search
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- yanky.nvim: yank ring
  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = { timer = 200 },
      preserve_cursor_position = { enabled = true },
    },
  },

  -- dial.nvim: smart increment (<C-a> goes to dial, so no select-all here)
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal("augment") end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal("augment") end, expr = true, desc = "Decrement" },
      {
        "g<C-a>",
        function() return require("dial.map").inc_gnormal("augment") end,
        expr = true,
        desc = "Increment (sequential)",
      },
      {
        "g<C-x>",
        function() return require("dial.map").dec_gnormal("augment") end,
        expr = true,
        desc = "Decrement (sequential)",
      },
      {
        "<C-a>",
        function() return require("dial.map").inc_visual("augment") end,
        mode = "v",
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function() return require("dial.map").dec_visual("augment") end,
        mode = "v",
        expr = true,
        desc = "Decrement",
      },
      {
        "g<C-a>",
        function() return require("dial.map").inc_gvisual("augment") end,
        mode = "v",
        expr = true,
        desc = "Increment (sequential)",
      },
      {
        "g<C-x>",
        function() return require("dial.map").dec_gvisual("augment") end,
        mode = "v",
        expr = true,
        desc = "Decrement (sequential)",
      },
    },
  },

  -- mini.ai: treesitter-aware text objects
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
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
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
