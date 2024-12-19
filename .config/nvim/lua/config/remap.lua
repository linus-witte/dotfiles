vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Open current directory' })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Undotree' })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = 'Git' })

-- Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Clipboard
vim.keymap.set('v', 'y', '"+y', { desc = 'Yank to system clipboard', noremap = true })
vim.keymap.set('v', 'p', '"+p', { desc = 'Past from system clipboard', noremap = true })

-- LSP Keymaps
vim.keymap.set("n", "gd", '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'LSP Rename' })
vim.keymap.set("n", "<leader>y", '<cmd>lua vim.lsp.buf.references()<CR>', { desc = 'LSP References' })

vim.keymap.set("i", "<C-h>", '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'LSP signature_help' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Action" })

vim.keymap.set('n', '<leader>k', function() vim.lsp.buf.format({ async = true }) end,
  { noremap = true, silent = true, desc = "LSP Format" })
