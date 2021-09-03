(function(config)
  vim.fn['plug#begin']('~/.config/nvim/plugged')
  for _, v in ipairs(config) do
    if type(v) == 'string' then
      vim.fn['plug#'](v)
    elseif type(v) == 'table' then
      local p = v[1]
      assert(p, 'Must specify package as first index.')
      v[1] = nil
      vim.fn["plug#"](p, v)
      v[1] = p
    end
  end
  vim.fn['plug#end']()
end){
  { 'dracula/vim', as = 'dracula' },
  { 'sonph/onehalf', rtp = 'vim/' },
  { 'folke/tokyonight.nvim', branch = 'main' },
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-compe', -- Auto completion
  { 'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate' },
  { 'terrortylor/nvim-comment', branch = 'main' }, -- Comment
  'nvim-lua/plenary.nvim',
  { 'lewis6991/gitsigns.nvim', branch = 'main' },
  'psliwka/vim-smoothie', -- Smooth scrolling
  'kyazdani42/nvim-web-devicons', -- Icons
  'romgrk/barbar.nvim',
  { 'kevinhwang91/rnvimr', branch = 'main' }, -- File explorer
  'lukas-reineke/indent-blankline.nvim', -- Indent lines
  'norcalli/nvim-colorizer.lua',
}

-- Set vim global variable prefixed with $namespace
local function setup(namespace)
  local g = vim.g
  return function(config)
           for k, v in pairs(config) do
             g[namespace .. '_' .. k] = v
           end
         end
end

-- Set keymaps
local keymap = require'utils'.keymap{ noremap = true, silent = true }

-- lsp
require 'lsp'

-- treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}

require'gitsigns'.setup {}

-- rnvimr
keymap {
  { 'n', '<C-n>', ':RnvimrToggle<CR>' },
}

-- barbar.nvim
keymap {
  { 'n', '<A-h>', ':BufferPrevious<CR>' },
  { 't', '<A-h>', '<C-\\><C-n>:BufferPrevious<CR>' },
  { 'n', '<A-l>', ':BufferNext<CR>' },
  { 't', '<A-l>', '<C-\\><C-n>:BufferNext<CR>' },
  { 'n', '<A-x>', ':BufferClose<CR>' },
  { 't', '<A-x>', '<C-\\><C-n>:BufferClose<CR>' },
  { 'n', '<C-s>', ':BufferPick<CR>' }, -- Buffer-picking mode
  { 't', '<C-s>', '<C-\\><C-n>:BufferPick<CR>' },
}

require'nvim_comment'.setup {}

require'indent_blankline'.setup {
  char = '│',
  use_treesitter = true,
  show_current_context = true,
  buftype_exclude = { 'terminal' },
  filetype_exclude = { 'help' },
}

require'colorizer'.setup({ '*' }, {
  rgb_fn = true
})
