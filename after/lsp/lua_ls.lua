-- lua_ls: knows the Neovim runtime (lazydev supplies the libs), keep it quiet
-- about the noisy checks this config trips
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      diagnostics = { disable = { "missing-fields" } },
    },
  },
}
