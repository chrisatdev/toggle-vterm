# toggle-vterm.nvim

A Neovim plugin to manage multiple terminal windows with toggling functionality. Open and hide horizontal and vertical terminals with simple keybindings.

## Features

- Open and hide horizontal and vertical terminal windows.
- Reuse existing terminal buffers to keep processes running in the background.
- Customizable keybindings.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

1. Add the following to your Neovim configuration:

```lua
{
    "chrisatdev/toggle-vterm.nvim",
    config = function()
        require("toggle-vterm").setup()
    end,
}
```

2. Run `:Lazy sync` to install the plugin.

## Configuration

### Default Keybindings

You can configure the keybindings in your `keymaps.lua` or equivalent file:

```lua
local toggle_vterm = require("toggle-vterm")

local opts = { noremap = true, silent = true }

-- Toggle horizontal terminal
vim.keymap.set("n", "<leader>th", function()
    toggle_vterm.toggle_terminal("horizontal")
end, opts)

-- Toggle vertical terminal
vim.keymap.set("n", "<leader>tv", function()
    toggle_vterm.toggle_terminal("vertical")
end, opts)

-- Exit to Normal mode in the terminal
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", opts)
```

### Custom Keybindings

You can change the keybindings to whatever you prefer. For example:

```lua
vim.keymap.set("n", "<leader>tt", function()
    toggle_vterm.toggle_terminal("horizontal")
end, opts)
```

## Usage

- `<leader>th`: Toggle horizontal terminal.
- `<leader>tv`: Toggle vertical terminal.
- `<C-x>`: Exit terminal mode and return to Normal mode.
- `<C-l>`: Clear the terminal screen (only in terminal mode).

## Contributing

Feel free to open issues or pull requests if you have suggestions or improvements!

## License

MIT
