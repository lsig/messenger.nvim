local M = {}

local function locate_gitdir()
  local current_dir = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git", current_dir .. ";")
  return git_dir ~= "" and vim.fn.fnamemodify(git_dir, ":p:h:h") or nil
end

local function get_commit_message()
  local gitdir = locate_gitdir()
  if not gitdir then
    return "Not a git repository"
  end

  local file_path = vim.fn.expand("%:p")
  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  -- Get the blame information for the current line
  local blame_cmd = string.format("git -C %s blame -L %d,%d --porcelain %s", gitdir, line_num, line_num, file_path)
  -- print("Blame Command:", blame_cmd) -- Debug print
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

local function print_commit_message()
  local info = get_commit_message()
  vim.api.nvim_echo({ { info, "Normal" } }, true, {})
end

local function setup()
  vim.api.nvim_create_user_command("MessengerPrint", print_commit_message, {})
end

M.setup = setup
M.locate_gitdir = locate_gitdir
M.print_commit_message = print_commit_message

return M
