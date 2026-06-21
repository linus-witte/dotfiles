return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Telescope find files' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Telescope live grep' },
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          '%.meta',
        },
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  { 'tpope/vim-fugitive', cmd = { 'Git', 'G' } },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>a', function() require('harpoon'):list():add() end, desc = 'Harpoon add file' },
      { '<C-e>', function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, desc = 'Harpoon menu' },
      { '<C-j>', function() require('harpoon'):list():select(1) end, desc = 'Harpoon file 1' },
      { '<C-l>', function() require('harpoon'):list():select(2) end, desc = 'Harpoon file 2' },
      { '<C-m>', function() require('harpoon'):list():select(3) end, desc = 'Harpoon file 3' },
      { '<C-n>', function() require('harpoon'):list():select(4) end, desc = 'Harpoon file 4' },
      { '<C-S-P>', function() require('harpoon'):list():prev() end, desc = 'Harpoon previous' },
      { '<C-S-N>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
    },
    opts = {},
  },
  { 'mbbill/undotree', cmd = 'UndotreeToggle' },
}
