local M = {}

local function locate_gitdir()
  local current_dir = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git", current_dir .. ";")
  return git_dir ~= "" and vim.fn.fnamemodify(git_dir, ":p:h:h") or nil
end

local function get_commit_info()
  local gitdir = locate_gitdir()
  if not gitdir then
    return "Not a git repository"
  end

  local file_path = vim.fn.expand("%:p")
  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  -- Get the blame information for the current line
  local blame_cmd = string.format("git -C %s blame -L %d,%d --porcelain %s", gitdir, line_num, line_num, file_path)
  local blame_output = vim.fn.system(blame_cmd)

  if vim.v.shell_error ~= 0 then
    return "Error executing git blame: " .. blame_output
  end

  -- Extract the commit hash from the blame output
  local commit_hash = blame_output:match("^(%x+)")
  if not commit_hash then
    return "Could not find commit hash for the current line"
  end

  -- Get the commit message for the found commit hash
  local message_cmd = string.format("git -C %s show -s --format=%%B %s", gitdir, commit_hash)
  local message = vim.fn.system(message_cmd)

  if vim.v.shell_error ~= 0 then
    return "Error getting commit message: " .. message
  end

  local info_cmd =
    string.format("git -C %s show -s --format='%%h | %%an | %%ad | %%s' --date=short %s", gitdir, commit_hash)
  local info = vim.fn.system(info_cmd)

  if vim.v.shell_error ~= 0 then
    return "Error getting commit info: " .. info
  end

  return info
end

local function notify_commit_message()
  local info = get_commit_info()

  -- Split the info into its components
  local hash, author, date, message = unpack(vim.tbl_map(vim.trim, vim.split(info, "|")))

  -- Prepare the notification message
  local notify_message =
    string.format("Commit (%s)\n%s - %s %s", vim.trim(hash), vim.trim(message), vim.trim(author), vim.trim(date))

  -- Send the notification
  vim.notify(notify_message, vim.log.levels.INFO, {
    title = string.format("Messenger.nvim"),
  })
end

local function show_commit_info_popup()
  local info = get_commit_info()

  -- Split the info into its components and trim each part
  local hash, author, date, message = unpack(vim.tbl_map(vim.trim, vim.split(info, "|")))

  -- Prepare the content for the floating window
  local content = {
    string.format("Commit: %s", hash),
    string.format("Author: %s", author),
    string.format("Date: %s", date),
    "",
    "Message",
    message,
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)

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
  vim.api.nvim_create_user_command("MessengerPrint", notify_commit_message, {})
  vim.api.nvim_create_user_command("MessengerPopup", show_commit_info_popup, {})
end

M.setup = setup
M.locate_gitdir = locate_gitdir
M.print_commit_message = notify_commit_message
M.show_commit_info_popup = show_commit_info_popup

return M
