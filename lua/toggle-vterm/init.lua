local M = {}

-- Variables to track the terminal states
local terminals = {
	horizontal = { buf = nil, win = nil },
	vertical = { buf = nil, win = nil },
}

-- Function to toggle a terminal in a specific orientation (horizontal or vertical)
function M.toggle_terminal(orientation)
	local term = terminals[orientation]
	if term.win and vim.api.nvim_win_is_valid(term.win) then
		-- If the terminal window is already open, hide it
		vim.api.nvim_win_hide(term.win)
		term.win = nil
	else
		-- If there is no terminal window, open or reuse the terminal
		if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
			-- Reuse the existing terminal buffer
			if orientation == "horizontal" then
				vim.cmd("split")                     -- Open a horizontal split
			else
				vim.cmd("vsplit")                    -- Open a vertical split
			end
			vim.api.nvim_win_set_buf(0, term.buf)  -- Set the terminal buffer in the new window
			term.win = vim.api.nvim_get_current_win() -- Save the terminal window
		else
			-- If there is no terminal buffer, create a new one
			if orientation == "horizontal" then
				vim.cmd("split | terminal")
			else
				vim.cmd("vsplit | terminal")
			end
			term.buf = vim.api.nvim_get_current_buf()              -- Save the terminal buffer
			term.win = vim.api.nvim_get_current_win()              -- Save the terminal window
			vim.api.nvim_buf_set_option(term.buf, "buflisted", false) -- Mark the terminal buffer as non-listable

			-- Set keybinding for Ctrl+L to clear the terminal
			vim.api.nvim_buf_set_keymap(term.buf, "t", "<C-l>", "<Cmd>clear<CR>", { noremap = true, silent = true })
		end
		vim.cmd("startinsert")      -- Enter Insert mode when opening the terminal
		vim.wo.number = false       -- Disable line numbers
		vim.wo.relativenumber = false -- Disable relative line numbers
	end
end

return M
