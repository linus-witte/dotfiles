vim.api.nvim_set_keymap("n", "<leader>h", ":lua require('config.header').switch_header_source()<CR>", { noremap = true, silent = true })

local M = {}

-- Function to quickly switch between header and source files
function M.switch_header_source()
  local current_file = vim.fn.expand("%:p")
  local header_extensions = { ".h", ".hpp", ".mli" }
  local source_extensions = { ".c", ".cpp", ".cc", ".ml" }

  -- Get the base name and current extension
  local basename = current_file:gsub("%.[^.]+$", "")
  local extension = vim.fn.expand("%:e")

  -- Determine the target extensions
  local extensions
  if vim.tbl_contains(header_extensions, "." .. extension) then
    extensions = source_extensions
  elseif vim.tbl_contains(source_extensions, "." .. extension) then
    extensions = header_extensions
  else
    vim.notify("Not a recognized source or header file.", vim.log.levels.WARN)
    return
  end

  -- Try to find the corresponding file
  for _, ext in ipairs(extensions) do
    local target = basename .. ext
    if vim.fn.filereadable(target) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(target))
      return
    end
  end

  vim.notify("No corresponding file found.", vim.log.levels.INFO)
end

return M
