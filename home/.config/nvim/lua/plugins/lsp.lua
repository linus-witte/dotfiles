return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        bashls = {
          cmd = { "bash-language-server", "start" },
        },
        csharp_ls = {
          cmd = { "csharp-ls" },
        },
        hls = {
          cmd = { "haskell-language-server-wrapper", "--lsp" },
        },
        lua_ls = {
          cmd = { "lua-language-server" },
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        marksman = {
          cmd = { "marksman", "server" },
        },
        ocamllsp = {
          cmd = { "/home/linus/.opam/default/bin/ocamllsp" },
          filetypes = { "ocaml", "reason" },
          root_markers = { "dune-project", "dune-workspace", "opam", ".git" },
        },
        pyright = {
          cmd = { "pyright-langserver", "--stdio" },
        },
        rust_analyzer = {
          cmd = { "rust-analyzer" },
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
                enable = true,
              },
            },
          },
        },
        ts_ls = {
          cmd = { "typescript-language-server", "--stdio" },
        },
      }

      local enabled_servers = {}
      for server, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(server, config)
        if vim.fn.executable(config.cmd[1]) == 1 then
          table.insert(enabled_servers, server)
        end
      end

      vim.lsp.enable(enabled_servers)
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    keys = {
      { "<C-K>", function() require("luasnip").expand() end, mode = "i", desc = "LuaSnip expand" },
      { "<C-L>", function() require("luasnip").jump(1) end, mode = { "i", "s" }, desc = "LuaSnip jump next" },
      { "<C-J>", function() require("luasnip").jump(-1) end, mode = { "i", "s" }, desc = "LuaSnip jump previous" },
      { "<C-E>", function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, mode = { "i", "s" }, desc = "LuaSnip change choice" },
    },
  },
}
