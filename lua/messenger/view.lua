local util = require("messenger.util")
local config = require("messenger.config")
local M = {}

function M.create_window(content)
  local opts = config.options
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)

  -- Define highlighting groups for colors
  vim.api.nvim_buf_add_highlight(buf, -1, "MessengerHeadings", 0, 0, 7)
  vim.api.nvim_buf_add_highlight(buf, -1, "MessengerHeadings", 1, 0, 7)
  vim.api.nvim_buf_add_highlight(buf, -1, "MessengerHeadings", 2, 0, 5)

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
    border = opts.window.border,
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

function M.messenger()
  local info, err = util.commit_info()

  if err then
    vim.notify(err, vim.log.levels.ERROR, {
      title = string.format("Messenger.nvim"),
    })
    return
  end

  local content = util.format_content(info)
  M.create_window(content)
end

return M
