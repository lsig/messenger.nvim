local M = {}

--- Configuration options for the Messenger.nvim plugin.
---
---@class MessengerOptions
---@field window table Configuration for the popup window.
---@field window.border string Border style for the popup window. Valid values: "none", "single", "double", "rounded", "solid", "shadow".
---@usage >lua
---  local options = {
---     window = {
---       border = "none",
---     },
---  }
--- <
local defaults = {
  window = {
    border = "none",
  },
}

---@type MessengerOptions
M.options = nil

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  vim.cmd("highlight MessengerHeadings guifg=#89b4fa")
end

return M
