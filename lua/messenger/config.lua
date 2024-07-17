local M = {}

--- Configuration options for the Messenger.nvim plugin.
---
---@class MessengerOptions
---@field window table Configuration for the popup window.
---@field window.border string Border style for the popup window. Valid values: "none", "single", "double", "rounded", "solid", "shadow".
---@usage >lua
---  local options = {
---     border = "none",
---     heading_hl = "#89b4fa"
---  }
--- <
local defaults = {
  border = "none",
  heading_hl = "#89b4fa",
}

---@type MessengerOptions
M.options = nil

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  vim.cmd("highlight MessengerHeadings guifg=" .. M.options.heading_hl)
end

return M
