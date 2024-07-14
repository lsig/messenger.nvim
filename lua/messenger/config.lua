local M = {}

---@class MessengerOptions
local defaults = {
  window = {
    border = "none",
  },
}

---@class MessengerOptions
M.options = nil

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  vim.cmd("highlight MessengerHeadings guifg=#89b4fa")
end

return M
