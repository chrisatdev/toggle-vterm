local M = {}
-- Variables to track the terminal states
local terminals = {
	horizontal = { buf = nil, win = nil, height = nil },
	vertical = { buf = nil, win = nil, width = nil },
}

-- Function to toggle a terminal in a specific orientation (horizontal or vertical)
function M.toggle_terminal(orientation)
	local term = terminals[orientation]

	if term.win and vim.api.nvim_win_is_valid(term.win) then
		-- Store current window dimensions before hiding
		if orientation == "horizontal" then
			term.height = vim.api.nvim_win_get_height(term.win)
		else
			term.width = vim.api.nvim_win_get_width(term.win)
		end
		-- Hide the terminal window
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

			-- Restore the previous dimensions if they exist
			if orientation == "horizontal" and term.height then
				vim.api.nvim_win_set_height(term.win, term.height)
			elseif orientation == "vertical" and term.width then
				vim.api.nvim_win_set_width(term.win, term.width)
			end
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

			-- Set default dimensions (opcional)
			if orientation == "horizontal" then
				term.height = vim.api.nvim_win_get_height(term.win)
			else
				term.width = vim.api.nvim_win_get_width(term.win)
			end

			-- Set keybinding for Ctrl+L to clear the terminal
			vim.api.nvim_buf_set_keymap(term.buf, "t", "<C-l>", "clear<CR>", { noremap = true, silent = true })

			-- Automatically close the terminal when the shell exits
			vim.api.nvim_create_autocmd("TermClose", {
				buffer = term.buf,
				callback = function()
					if vim.api.nvim_win_is_valid(term.win) then
						vim.api.nvim_win_close(term.win, true)
					end
					term.buf = nil
					term.win = nil
					-- Reset size as well when terminal is closed
					if orientation == "horizontal" then
						term.height = nil
					else
						term.width = nil
					end
				end,
			})
		end
		vim.cmd("startinsert")      -- Enter Insert mode when opening the terminal
		vim.wo.number = false       -- Disable line numbers
		vim.wo.relativenumber = false -- Disable relative line numbers
	end
end

-- Add a function to manually save current terminal dimensions
function M.save_terminal_dimensions()
	for orientation, term in pairs(terminals) do
		if term.win and vim.api.nvim_win_is_valid(term.win) then
			if orientation == "horizontal" then
				term.height = vim.api.nvim_win_get_height(term.win)
			else
				term.width = vim.api.nvim_win_get_width(term.win)
			end
		end
	end
end

-- Add auto-command to save terminal dimensions when changing windows
function M.setup()
	vim.api.nvim_create_autocmd("WinLeave", {
		callback = function()
			M.save_terminal_dimensions()
		end,
	})
end

return M
