-- Treesitter, LSP, completion, formatting.

-- nvim-treesitter, main branch: parsers compile locally (needs tree-sitter CLI + cc)
do
  local parsers = {
    "bash",
    "css",
    "diff",
    "gitignore",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "vue",
    "yaml",
  }

  -- Install missing parsers (existing ones short-circuit)
  vim.schedule(function()
    pcall(function()
      require("nvim-treesitter").install(parsers)
    end)
  end)

  -- Treesitter highlight for every buffer that has a parser
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("benben_treesitter", { clear = true }),
    callback = function(args)
      -- filetype ≠ parser language (sh→bash, js→javascript...); map first
      local lang = vim.treesitter.language.get_lang(args.match) or args.match
      if pcall(vim.treesitter.language.inspect, lang) then
        pcall(vim.treesitter.start, args.buf, lang)
      end
    end,
  })

  -- Parsers stay in sync with the plugin version
  vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("benben_treesitter_update", { clear = true }),
    callback = function(args)
      local data = args.data
      local path = data and data.path or ""
      local kind = data and data.kind or ""
      if path:match("nvim%-treesitter") and (kind == "install" or kind == "update") then
        vim.schedule(function()
          pcall(vim.cmd.TSUpdate)
        end)
      end
    end,
  })
end

-- blink.cmp: completion. Enter accepts, docs after 200ms, auto-brackets,
-- ghost text off (no AI completions to clash with)
require("blink.cmp").setup({
  keymap = { preset = "enter" },
  completion = {
    ghost_text = { enabled = false },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    accept = { auto_brackets = { enabled = true } },
  },
  signature = { enabled = true },
  cmdline = { enabled = true },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
})

-- mason: installs language servers and formatters, never auto-updates
require("mason").setup({})

-- mason-tool-installer: the toolchain, installed on start
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",
    "vtsls",
    "eslint-lsp",
    "tailwindcss-language-server",
    "vue-language-server",
    "pyright",
    "marksman",
    "json-lsp",
    "taplo",
    "prettierd",
    "oxfmt",
    "stylua",
    "shfmt",
    "sqlfluff",
  },
  run_on_start = true,
  start_delay = 2000,
})

-- nvim-lspconfig: server defaults; turning them on is one line (0.12)
vim.lsp.enable({ "lua_ls", "vtsls", "eslint", "tailwindcss", "vue_ls", "pyright", "marksman", "jsonls", "taplo" })

-- conform: format on save, 1000ms timeout, LSP fallback
local conform = require("conform")
-- oxfmt only when the project opted into it
conform.formatters.oxfmt = {
  condition = function(ctx)
    return vim.fs.root(ctx.filename, { ".oxfmtrc.json", ".oxfmtrc", "vite.config.ts" }) ~= nil
  end,
}
local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }
conform.setup({
  formatters_by_ft = {
    javascript = web,
    javascriptreact = web,
    typescript = web,
    typescriptreact = web,
    json = web,
    jsonc = web,
    css = web,
    scss = web,
    html = web,
    markdown = web,
    yaml = web,
    lua = { "stylua" },
    sh = { "shfmt" },
    sql = { "sqlfluff" },
    toml = { "taplo" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { async = false, timeout_ms = 1000, lsp_format = "fallback" }
  end,
})

-- mini.pairs: autopairs in insert and command mode
require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = false } })

-- ts-comments: correct comment strings for tsx/vue
require("ts-comments").setup({})

-- lazydev: neovim API + snacks completions while editing this config
do
  local library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  }
  local snacks = vim.fs.find("snacks.nvim", { path = vim.fn.stdpath("data") .. "/site/pack", type = "directory" })[1]
  if snacks then
    library[#library + 1] = { path = snacks, words = { "Snacks" } }
  end
  require("lazydev").setup({ library = library })
end

-- inc-rename: rename with a live preview window
require("inc_rename").setup({})
