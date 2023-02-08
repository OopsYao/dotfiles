local seto = require("utils").setopt "o"
local setg = require("utils").setopt "g"
local keymap = require("utils").keymap { noremap = true, silent = true }

setg {
  -- Leader key
  mapleader = " ",
  tex_flavor = "latex",
  copilot_node_command = "~/.nvm/versions/node/v16.18.1/bin/node",
}

seto {
  -- Line number
  number = true,
  relativenumber = true,

  -- Highlight current line
  cursorline = true,

  -- Tab and space
  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  list = true,
  listchars = "tab:⍿▸,trail:·",

  -- Hide unused buffer (for barbar.nvim navigation)
  hidden = true,

  -- Mouse
  mouse = "a",

  -- Use gui colors
  termguicolors = true,

  -- Hide tilde
  fillchars = "eob: ",

  -- Alaways show sign column
  signcolumn = "yes",

  -- Confirm dialog when necessary
  confirm = true,

  -- Disable showmode (mode message on the last line)
  showmode = false,
}

keymap {
  -- Clear highlight
  { "n", "<esc>", ":noh<CR><esc>" },
  { "n", "<leader>w", "<C-w>" },
  -- Exit terminal mode
  { "t", "<C-\\>", "<C-\\><C-N>" },
}

-- Plugins
require "plugins"

-- Disable line number in terminal mode
vim.cmd "au TermOpen * setlocal nonumber norelativenumber"
