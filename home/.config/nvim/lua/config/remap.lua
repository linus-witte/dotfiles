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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP Definition" }))
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP Rename" }))
    vim.keymap.set("n", "<leader>y", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP References" }))
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP Signature Help" }))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP Code Action" }))
    vim.keymap.set("n", "<leader>k", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "LSP Format" }))
  end,
})
