local M = {}

function M.create_window(content)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)

  -- Define highlighting groups for colors
  vim.api.nvim_buf_add_highlight(buf, -1, "MessengerHeadings", 0, 0, 7)
  vim.api.nvim_buf_add_highlight(buf, -1, "MessengerHeadings", 1, 0, 7)

  -- Adjust height and width based on content
  local width = 0
  for _, line in ipairs(content) do
    if #line > width then
      width = #line
    end
  end
  local height = #content

  local win_config = {
    relative = "cursor",
    style = "minimal",
    width = width + 2,
    height = height,
    row = 1,
    col = 1,
    border = "single",
    zindex = 100,
  }

  local win_id = vim.api.nvim_open_win(buf, false, win_config)

  vim.wo[win_id].foldenable = false
  vim.wo[win_id].wrap = false
  vim.wo[win_id].list = false

  local win_hl = "FloatBorder:MessengerBorder,FloatTitle:MessengerTitle"
  vim.wo[win_id].winhighlight = win_hl

  vim.api.nvim_create_autocmd("CursorMoved", {
    once = true,
    callback = function()
      vim.api.nvim_win_close(win_id, true)
    end,
  })
end

return M
