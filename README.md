# ✨Messenger

Read the hidden commit message under your cursor, from the comfort of your favorite editor

video

## 💬 Show the commit message under cursor in a pop-up window

Yep, there is not much else to it 🔥

## 🎯 Goals

- Aid in understanding someone else's code
- Get people to write better commit messages

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- Lua
{
  "lsig/messenger.nvim",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}
```

## ⚙️ Configuration

**Messenger** comes with the following defaults:

```lua
{
    border = "none", -- Valid values: "none", "single", "double", "rounded", "solid", "shadow".
    heading_hl = "#89b4fa" -- Any hex color that your terminal supports
}
```

## 🚀 Usage

Toggle **Messenger** with `:MessengerShow`.

Alternatively you can start **Messenger** with the `Lua` API and pass any additional options:

```lua
require("messenger").show()
```

## 🤝 Contribution

Contributions are welcome! Please see the CONTRIBUTING.md for more information.

## Inspiration

- [rhysd/git-messenger.vim](https://github.com/rhysd/git-messenger.vim)
