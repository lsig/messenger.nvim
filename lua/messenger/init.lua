local config = require("messenger.config")
local view = require("messenger.view")

--- *Messenger.nvim* Show the commit message under the cursor
---
--- MIT License Copyright (c) 2024 lsig
---
--- ==============================================================================
---
--- Features:
--- - Show the most recent commit message under the cursor
---
--- # Setup ~
---
--- Setup with `require('messenger').setup({})` (replace `{}` with your
--- `config` table) or require('messenger').setup() for the default coniguration.
---
--- See |Messenger.options| for `options` structure and default values.
---
local Messenger = {}

--- Module setup
---
---@param options MessengerOptions|nil Module config table. See |Messenger.options|.
---
---@usage >lua
---   require('messenger').setup() -- use default config
---   -- OR
---   require('messenger').setup({}) -- replace {} with your config table
--- <
Messenger.setup = config.setup

--- Retrieve and display commit information in a floating window
---
--- This function uses `util.commit_info` to get the commit information and formats it using `util.format_content`.
--- The formatted content is then displayed in a floating window using `create_window`.
---
--- If there is an error retrieving the commit information, a notification is displayed.
---
--- @usage
---   require('messenger').show()
---
---   -- OR
---
---   Use :MessengerShow in Neovim to call this function
---
Messenger.show = view.messenger

vim.api.nvim_create_user_command("MessengerShow", Messenger.show, {})

return Messenger
