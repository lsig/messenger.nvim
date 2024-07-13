local util = require("messenger.util")
local git = require("messenger.git")
local M = {}

local function commit_info()
  local gitdir = util.locate_gitdir()
  if not gitdir then
    return nil, "Not a git repository"
  end

  local info, err = git.blame_info(gitdir)
  if err then
    return nil, err
  end

  -- Get the commit message for the found commit hash
  local message, err = git.commit_message(gitdir, info.commit_hash)

  if err then
    return nil, err
  end

  info.commit_msg = message

  return info
end

local function notify_commit_message()
  local info, err = commit_info()

  if err then
    vim.notify(err, vim.log.levels.ERROR, {
      title = string.format("Messenger.nvim"),
    })
  end

  -- Prepare the notification message
  local notify_message =
    string.format("Commit (%s)\n%s - %s %s", info.commit_hash, info.commit_msg, info.author, info.date)

  -- Send the notification
  vim.notify(notify_message, vim.log.levels.INFO, {
    title = string.format("Messenger.nvim"),
  })
end

local function show_commit_info_popup()
  local info, err = commit_info()

  if err then
    vim.notify(err, vim.log.levels.ERROR, {
      title = string.format("Messenger.nvim"),
    })
  end

  -- Split commit message into lines
  local msg_lines = vim.split(info.commit_msg, "\n")

  -- Prepare the content for the floating window
  local content = {
    string.format("Commit: %s", info.commit_hash),
    string.format("Author: %s %s", info.author, info.author_email),
    "",
  }

  -- Append commit message lines
  for _, line in ipairs(msg_lines) do
    if line:match("%S") then -- Check if the line contains any non-whitespace characters
      table.insert(content, line)
    end
  end

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

local function setup()
  -- Define custom highlight groups
  vim.cmd("highlight MessengerHeadings guifg=#89b4fa")

  vim.api.nvim_create_user_command("MessengerPrint", notify_commit_message, {})
  vim.api.nvim_create_user_command("MessengerPopup", show_commit_info_popup, {})
end

M.setup = setup
M.print_commit_message = notify_commit_message
M.show_commit_info_popup = show_commit_info_popup

return M
