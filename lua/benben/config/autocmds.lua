-- Autocmds that need no plugin.

local group = vim.api.nvim_create_augroup("benben", { clear = true })

-- Yanked text flashes briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Markdown spell stays off (crash guard carried over from the old config)
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
