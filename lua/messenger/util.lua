local M = {}

function M.locate_gitdir()
  local current_dir = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git", current_dir .. ";")
  return git_dir ~= "" and vim.fn.fnamemodify(git_dir, ":p:h:h") or nil
end

function M.format_content(info)
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

  return content
end

return M
