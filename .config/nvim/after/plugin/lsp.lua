local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here 
    -- with the ones you want to install
    ensure_installed = {'lua_ls', 'clangd', 'bashls', 'pylsp'},
    handlers = {
        lsp_zero.default_setup,
    },
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp_zero.default_keymaps ({
    ["<C-Space>"] = cmp.mapping.complete();
})

local lspconfig = require("lspconfig")
lspconfig.pylsp.setup {
    on_attach = custom_attach,
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = true, executable = "pylint" },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = { enabled = true },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                pyls_isort = { enabled = true },
            },
        },
    },
    flags = {
        debounce_text_changes = 200,
    },
    capabilities = capabilities,
}
