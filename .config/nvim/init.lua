require("linus")

-- enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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

-- vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true
