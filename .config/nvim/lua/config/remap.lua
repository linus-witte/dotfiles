vim.g.mapleader = " "

-- Open directory 
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Open current directory' } )

-- UndotreeToggle
-- vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Undotree toggle' } )

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = 'Git' } )

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
