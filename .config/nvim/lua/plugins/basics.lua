return 
{
    {
        'nvim-treesitter/nvim-treesitter', 
        run = ":TSUpdate" 
    },
    {
        'nvim-telescope/telescope.nvim', 
        branch = '0.1.x', 
        dependencies = { 'nvim-lua/plenary.nvim' },
        opt = true,
    },
    {
        'folke/which-key.nvim', 
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    },
    {
        'nvim-lualine/lualine.nvim', 
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opt = true,
    },
    {
        'folke/todo-comments.nvim',
        ops = {} 
    },
    {
        'catppuccin/nvim', 
        name = 'catppuccin', 
        priority = 1000
    },
    -- TODO Move this
    { 'tpope/vim-fugitive' },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    }

    -- {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
    -- {'neovim/nvim-lspconfig'},
    -- {'hrsh7th/cmp-nvim-lsp'},
    -- {'hrsh7th/nvim-cmp'},
    -- {'L3MON4D3/LuaSnip'}
}

