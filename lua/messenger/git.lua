local M = {}

function M.blame_info(gitdir)
  local file_path = vim.fn.expand("%:p")
  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  -- Get the blame information for the current line
  local blame_cmd = string.format("git -C %s blame -L %d,%d --porcelain %s", gitdir, line_num, line_num, file_path)
  local blame_output = vim.fn.system(blame_cmd)

  if vim.v.shell_error ~= 0 then
    return nil, "Error executing git blame: " .. blame_output
  end

  -- Parse the blame output
  local commit_hash = blame_output:match("^(%x+)")
  if not commit_hash then
    return nil, "Failed to extract commit hash from blame output"
  end

  local author = blame_output:match("author%s+([^\n]+)")
  if not author then
    return nil, "Failed to extract author from blame output"
  end

  local author_email = blame_output:match("author%-mail%s+<([^>]+)>")
  if not author_email then
    return nil, "Failed to extract author email from blame output"
  end

  local author_time = blame_output:match("author%-time (%d+)")
  if not author_time then
    return nil, "Failed to extract author time from blame output"
  end

  -- Convert author_time to a readable format
  local date = os.date("%Y-%m-%d", tonumber(author_time))
  if not date then
    return nil, "Failed to convert author time to date"
  end

  local info = {
    author = author,
    author_email = author_email,
    commit_hash = commit_hash,
    date = date,
  }

  -- Trim all string values in the table
  return vim.tbl_map(function(v)
    return type(v) == "string" and vim.trim(v) or v
  end, info)
end

function M.commit_message(gitdir, commit_hash)
  local message_cmd = string.format("git -C %s show -s --format=%%B %s", gitdir, commit_hash)
  local message = vim.fn.system(message_cmd)

  if vim.v.shell_error ~= 0 then
    return nil, "Error getting commit message: " .. message
  end

  return message
end

function M.locate_gitdir()
  local current_dir = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git", current_dir .. ";")
  return git_dir ~= "" and vim.fn.fnamemodify(git_dir, ":p:h:h") or nil
end

return M
