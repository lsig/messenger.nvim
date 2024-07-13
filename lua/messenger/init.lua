local config = require("messenger.config")
local view = require("messenger.view")
local M = {}

M.setup = config.setup
M.messenger = view.messenger

vim.api.nvim_create_user_command("MessengerShow", M.messenger, {})

return M
