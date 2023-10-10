local M = {}

function M.replace()
  local _, line_start, col_start, _ = unpack(vim.fn.getpos("'<"))
  local _, line_end, col_end, _ = unpack(vim.fn.getpos("'>"))
  local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
  local selected_text = lines[1]:sub(col_start, #lines[1])

  if #lines > 1 then
    for i = 2, #lines do
      selected_text = selected_text .. "\n" .. lines[i]
      if i == #lines then
        selected_text = selected_text:sub(1, col_end)
      end
    end
  else
    selected_text = selected_text:sub(1, col_end - col_start + 1)
  end

  local escaped_selected_text = selected_text:gsub("([^%w])", "%%%1")
  local replace_text = vim.fn.input("Replace with: ")

  if replace_text == "" then
    print("")
    return
  end

  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local count = 0
  for i, line in ipairs(all_lines) do
    all_lines[i] = line:gsub(escaped_selected_text, replace_text)
    count = count + 1
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, all_lines)
  print(" -> replaced " .. count .. " occurrences")
end

vim.cmd('command! -range Replace lua require("nvim-replace").replace()')

return M
