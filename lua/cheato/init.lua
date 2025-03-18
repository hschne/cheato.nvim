--- *cheato.nvim*
---
--- MIT License Copyright (c) 2025 Hans Schnedlitz
---
--- ==============================================================================
---
--- Cheato lists available markdown cheat files and renders them in a floating window.
---
--- # Setup ~
---
--- This module needs a setup with `require('cheato').setup({})` (replace `{}` with your `config` table). See |Cheato.config| for available config settings.

-- Module definition ==========================================================
local Cheato = {}
local H = {}

-- Default configuration

-- Setup function to override defaults
---@param opts? table Configuration options to override defaults
---@return nil
function Cheato.setup(opts)
	Cheato.config = vim.tbl_deep_extend("force", Cheato.config, opts or {})
	-- Ensure the directory path is expanded
	if Cheato.config.directory then
		Cheato.config.directory = vim.fn.expand(Cheato.config.directory)
	end

	-- Create the Cheato user command
	vim.api.nvim_create_user_command("Cheato", function()
		Cheato.show_cheat_sheets()
	end, {
		desc = "Open cheatsheet",
	})
end

--- Module config
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
Cheato.config = {
	directory = "~/Documents/cheatsheets",
}

-- Main function to show and select cheatsheets
--
---@return nil
function Cheato.show_cheat_sheets()
	local cheat_sheets = H.get_cheat_sheets()

	if #cheat_sheets == 0 then
		vim.notify("No cheat sheets found in " .. Cheato.config.directory, vim.log.levels.WARN)
		return
	end

	local display_names = {}
	local file_map = {}

	for _, file in ipairs(cheat_sheets) do
		local display_name = H.format_display_name(file)
		table.insert(display_names, display_name)
		file_map[display_name] = file
	end

	local fzf = require("fzf-lua")

	fzf.fzf_exec(display_names, {
		prompt = "Cheat Sheets > ",
		winopts = {
			width = 0.3,
			height = 0.2,
			preview = {
				hidden = "hidden",
			},
		},
		actions = {
			["default"] = function(selected)
				if selected and selected[1] then
					H.show_cheat_sheet(file_map[selected[1]])
				end
			end,
		},
	})
end

-- Helper data ================================================================
-- Module default config

-- Get all markdown files from the configured directory
---@return string[] List of cheatsheet file paths
function H.get_cheat_sheets()
	if vim.fn.isdirectory(Cheato.config.directory) == 0 then
		vim.notify("Cheatsheet directory does not exist: " .. Cheato.config.directory, vim.log.levels.ERROR)
		return {}
	end

	-- Use vim.fn.glob to find all markdown files
	local files = vim.fn.glob(Cheato.config.directory .. "/**/*.md", true, true)
	return files
end

--- Format a given filepath for nicer display
---@param filepath string Path to the cheatsheet file
---@return string Formatted display name without extension and capitalized
function H.format_display_name(filepath)
	local filename = filepath:match("([^/]+)$")
	local name_without_ext = filename:gsub("%.md$", "")
	return name_without_ext:gsub("^%l", string.upper)
end

-- Create and open a floating window
---@return number buffer Buffer handle
---@return number window Window handle
function H.open_floating_window()
	local width = math.min(vim.o.columns - 4, 120)
	local height = math.min(vim.o.lines - 4, 40)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)
	return buf, win
end

-- Setup keymaps for closing the cheatsheet window
---@param buf number Buffer handle
---@return nil
function H.setup_buffer_keymaps(buf)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
end

-- Display selected cheatsheet in a floating window
---@param filepath string Path to the cheatsheet file to display
---@return nil
function H.show_cheat_sheet(filepath)
	local file = io.open(filepath, "r")
	if not file then
		vim.notify("Cannot open file: " .. filepath, vim.log.levels.ERROR)
		return
	end

	local content = file:read("*all")
	file:close()

	local buf, _ = H.open_floating_window()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
	local display_name = H.format_display_name(filepath)
	vim.api.nvim_buf_set_name(buf, display_name .. " Cheatsheet")
	H.setup_buffer_keymaps(buf)

	vim.bo.filetype = "markdown"
	vim.bo.buftype = "nofile"
	vim.bo.modifiable = false
	vim.bo.buflisted = false
	vim.bo.swapfile = false
	vim.wo.number = false
	vim.wo.relativenumber = false
end

return Cheato
