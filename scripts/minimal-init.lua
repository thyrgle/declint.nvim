-- Minimal init for testing declint.nvim headless or in terminal
-- recordings:
--
--   nvim -u /path/to/declint.nvim/scripts/minimal-init.lua app.py
--
-- Puts the plugin on the runtimepath (repo checkout, no install) and
-- runs setup() with defaults.

local here = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
vim.opt.runtimepath:prepend(vim.fn.fnamemodify(here, ':h:h'))

require('declint').setup()
