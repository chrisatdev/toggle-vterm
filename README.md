# toggle-vterm.nvim

A Neovim plugin to manage multiple terminal windows with toggling functionality. Open and hide horizontal and vertical terminals with simple keybindings.

## Features

- Open and hide horizontal and vertical terminal windows.
- Reuse existing terminal buffers to keep processes running in the background.
- Automatically close the terminal when the shell exits (e.g., when running `exit`).
- Customizable keybindings.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "chrisatdev/toggle-vterm",
    keys = {
        -- Toggle horizontal terminal
        {
            "<leader>th",
            function()
                require("toggle-vterm").toggle_terminal("horizontal")
            end,
            desc = "Toggle horizontal terminal",
            mode = "n",
        },
        -- Toggle vertical terminal
        {
            "<leader>tv",
            function()
                require("toggle-vterm").toggle_terminal("vertical")
            end,
            desc = "Toggle vertical terminal",
            mode = "n",
        },
        -- Exit terminal mode
        {
            "<C-x>",
            "<C-\\><C-n>",
            desc = "Exit terminal mode",
            mode = "t",
        },
        -- Clear terminal screen
        {
            "<C-l>",
            "<Cmd>clear<CR>",
            desc = "Clear terminal screen",
            mode = "t",
        },
    },
}
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
