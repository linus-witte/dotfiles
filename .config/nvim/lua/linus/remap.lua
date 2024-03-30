vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Open current directory' } )
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Undotree toggle' } )
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = 'Git' } )


