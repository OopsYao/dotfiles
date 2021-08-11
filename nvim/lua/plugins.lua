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
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-compe', -- Auto completion
  { 'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate' },
  { 'terrortylor/nvim-comment', branch = 'main' }, -- Comment
  'nvim-lua/plenary.nvim',
  { 'lewis6991/gitsigns.nvim', branch = 'main' },
  'psliwka/vim-smoothie', -- Smooth scrolling
  'kyazdani42/nvim-web-devicons', -- Icons
  'romgrk/barbar.nvim',
  'kyazdani42/nvim-tree.lua', -- File explorer
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

-- nvim-tree
setup'nvim_tree' {
  side = 'right',
  auto_open = 1, -- Auto open when nvim started
  quit_on_open = 1, -- Auto close after open a file
  git_hl = 1, -- Dim git ignored files
  icons = { default = '', git = { ignored = '' } },
  ignore = { '.git', 'node_modules', '__pycache__' },
}
keymap {
  { 'n', '<C-n>', ':NvimTreeToggle<CR>' },
}

-- barbar.nvim
keymap {
  { 'n', '<A-h>', ':BufferPrevious<CR>' },
  { 'n', '<A-l>', ':BufferNext<CR>' },
  { 'n', '<A-x>', ':BufferClose<CR>' },
  { 'n', '<C-s>', ':BufferPick<CR>' }, -- Buffer-picking mode
}

require'nvim_comment'.setup {}

require'indent_blankline'.setup {
  char = '│',
  use_treesitter = true,
  show_current_context = true,
  buftype_exclude = { 'terminal' },
}

require'colorizer'.setup({ '*' }, {
  rgb_fn = true
})
