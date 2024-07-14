local git = require("messenger.git")
local M = {}

function M.commit_info()
  local gitdir = git.locate_gitdir()
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

function M.format_content(info)
  -- Split commit message into lines
  local msg_lines = vim.split(info.commit_msg, "\n")

  -- Prepare the content for the floating window
  local content = {
    string.format("Commit: %s", info.commit_hash),
    string.format("Author: %s %s", info.author, info.author_email),
    string.format("Date:   %s", info.date),
    "",
  }

  -- Append commit message lines
  for _, line in ipairs(msg_lines) do
    table.insert(content, line)
  end

  -- Remove last line if it is only whitespace
  local last_line = content[#content]

  if last_line:match("^%s*$") then
    table.remove(content)
  end

  return content
end

return M
