require("config.lazy")
require('config.remap')
require('config.header')

-- enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

-- disable mouse support
vim.opt.mouse = ""

-- disable show mode, because it is already displayed by lualine
vim.opt.showmode = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.cursorline = true
vim.opt.updatetime = 50

vim.opt.scrolloff = 8

vim.opt.termguicolors = true

vim.opt.spelllang = 'en_us'
vim.opt.spell = true;

vim.cmd.colorscheme "catppuccin"
