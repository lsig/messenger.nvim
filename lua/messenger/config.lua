local view = require("messenger.view")
local M = {}

M.options = nil

local defaults = {
  window = {
    border = "none",
  },
}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  vim.cmd("highlight MessengerHeadings guifg=#89b4fa")
  vim.api.nvim_create_user_command("MessengerShow", view.messenger, {})
end

return M
