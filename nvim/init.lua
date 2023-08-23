local seto = require("utils").setopt "o"
local setg = require("utils").setopt "g"
local keymap = require("utils").keymap { noremap = true, silent = true }

setg {
  -- Leader key
  mapleader = " ",
  tex_flavor = "latex",
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

  -- Hide tilde and set fold line char and diff char
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:╱]],

  -- Alaways show sign column
  signcolumn = "yes",

  -- Confirm dialog when necessary
  confirm = true,

  -- Disable showmode (mode message on the last line)
  showmode = false,

  scrolloff = 15,
}

keymap {
  -- Clear highlight
  { "n", "<esc>", ":noh<CR><esc>" },
  { "n", "<leader>w", "<C-w>" },
  { "n", "<C-h>", "<C-w>h" },
  { "n", "<C-j>", "<C-w>j" },
  { "n", "<C-k>", "<C-w>k" },
  { "n", "<C-l>", "<C-w>l" },
  -- Exit terminal mode
  { "t", "<C-\\>", "<C-\\><C-N>" },
  -- Nvim diagnostics
  { "n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" } },
  { "n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" } },
  { "n", "<leader>do", vim.diagnostic.open_float, { desc = "Display diagnostic info in float text" } },
}

-- Plugins
require "plugins"

-- Disable line number in terminal mode
vim.cmd "au TermOpen * setlocal nonumber norelativenumber"

-- Custom diagnostic UI
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
-- Gitgutter and LSP both use signcolumn,
-- hence use numhl for LSP when there is gitgutter
local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
local gitgutter = true
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, gitgutter and { numhl = hl } or { text = icon, texthl = hl })
end
vim.diagnostic.config {
  virtual_text = {
    -- Can be a function in future release
    -- https://github.com/neovim/neovim/pull/22965
    prefix = "●",
  },
}
