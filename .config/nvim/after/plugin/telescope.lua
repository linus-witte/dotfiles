local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })


local telescope = require("telescope")
telescope.setup({
  defaults = {
    file_ignore_patterns = {
      "%.meta"
    }
  }
})
