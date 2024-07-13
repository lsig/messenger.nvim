local util = require("messenger.util")
local view = require("messenger.view")
local M = {}

local function messenger()
  local info, err = util.commit_info()

  if err then
    vim.notify(err, vim.log.levels.ERROR, {
      title = string.format("Messenger.nvim"),
    })
    return
  end

  local content = util.format_content(info)
  view.create_window(content)
end

local function setup()
  -- Define custom highlight groups
  vim.cmd("highlight MessengerHeadings guifg=#89b4fa")

  vim.api.nvim_create_user_command("MessengerPopup", messenger, {})
end

M.setup = setup
M.messenger = messenger

return M
