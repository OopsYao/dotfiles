local seto = require'utils'.setopt('o')
local setg = require'utils'.setopt('g')
local keymap = require'utils'.keymap{ noremap = true, silent = true }

setg {
  -- Leader key
  mapleader = ' ',
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
  listchars = 'tab:⍿▸,trail:·',

  -- Hide unused buffer (for barbar.nvim navigation)
  hidden = true,

  -- Mouse
  mouse = 'a',

  -- Use gui colors
  termguicolors = true,

  -- Hide tilde
  fillchars = 'eob: ',

  -- Alaways show sign column
  signcolumn = 'yes',

  -- Confirm dialog when necessary
  confirm = true,

  -- Disable showmode (mode message on the last line)
  showmode = false,
}

keymap {
  -- Clear highlight
  { 'n', '<esc>', ':noh<CR><esc>' },
  { 'n', '<leader>w', '<C-w>' },
  -- Exit terminal mode
  { 't', '<C-\\>', '<C-\\><C-N>' },
}


-- Plugins
require 'plugins'

-- Disable line number in terminal mode
vim.cmd 'au TermOpen * setlocal nonumber norelativenumber'

-- Colorscheme based on auto background setting event
colo = (function()
    local init = true
    return function(mode)
        if (mode == 'light') then
            vim.cmd 'colo tokyonight' -- light theme
            if (init) then
                setg { airline_theme = 'onehalflight' }
                init = false
            else
                vim.cmd 'AirlineTheme onehalflight'
            end
        else
            vim.cmd 'colo tokyonight' -- dark theme
            if (init) then
                setg { airline_theme = 'dracula' }
                init = false
            else
                vim.cmd 'AirlineTheme dracula'
            end
        end
    end
end)()
colo 'dark' -- Default. If the terminal is in default mode (dark), no event will be emitted.
vim.cmd 'au OptionSet background :lua colo(vim.o.bg)'
