return {
  -- nvim-treesitter, main branch: parsers compile locally (needs tree-sitter CLI + cc)
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
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
          if pcall(vim.treesitter.language.inspect, args.match) then
            pcall(vim.treesitter.start, args.buf)
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
    end,
  },
}
