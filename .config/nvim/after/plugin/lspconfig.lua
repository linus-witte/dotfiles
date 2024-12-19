local lspconfig = require('lspconfig')

lspconfig.pyright.setup { }
lspconfig.marksman.setup { }
lspconfig.ocamllsp.setup {
  cmd = { "/home/linus/.opam/default/bin/ocamllsp" },
  filetypes = { "ocaml", "reason" },
  root_dir = lspconfig.util.root_pattern(".git", "dune-project", "dune-workspace", "opam"),
}
lspconfig.ts_ls.setup { }
lspconfig.csharp_ls.setup { }
lspconfig.bashls.setup { }
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Neovim uses LuaJIT
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" }, -- Recognize `vim` as a global
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- Add Neovim runtime files
        checkThirdParty = false, -- Optional: Avoid extra checks
      },
      telemetry = {
        enable = false, -- Disable telemetry
      },
    },
  },
})
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_ref",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true
      }
    }
  }
})
