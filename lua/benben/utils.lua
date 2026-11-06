-- Utilities shared across the config.

local M = {}

-- Project root: first marker found searching upward from the buffer.
-- Same marker list the article uses for the statusline.
function M.root()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = buf ~= "" and vim.fs.dirname(buf) or vim.uv.cwd()
  local marker = vim.fs.find({
    ".git",
    "lua",
    "package.json",
    "Makefile",
    "Cargo.toml",
    "go.mod",
    "pyproject.toml",
  }, { upward = true, path = start, stop = vim.fs.dirname(start) ~= "" and vim.uv.os_homedir() or start })
  return marker[1] and vim.fs.dirname(marker[1]) or vim.uv.cwd()
end

return M
