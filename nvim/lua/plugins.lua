vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
require('packer').startup({function()
  use { 'dracula/vim', as = 'dracula' }
  use { 'sonph/onehalf', rtp = 'vim/' }
  use { 'folke/tokyonight.nvim', branch = 'main' }
  use { 'projekt0n/github-nvim-theme', config = function() require'colors' end }
  use { 
    'neovim/nvim-lspconfig',
    config = function() require 'lsp' end,
  }
  use 'hrsh7th/nvim-compe' -- Auto completion
  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true
        }
      }
    end,
  }
  use {
    'terrortylor/nvim-comment',
    branch = 'main',
    config = function() require('nvim_comment').setup() end,
  } -- Comment
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require'gitsigns'.setup()
    end,
  }
  use 'psliwka/vim-smoothie' -- Smooth scrolling
  use {
    'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'},
    config = function()
      local keymap = require'utils'.keymap{ noremap = true, silent = true }
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
      vim.g.bufferline = {
        auto_hide = true,
      }
    end,
  }
  use {
    'kevinhwang91/rnvimr', branch = 'main',
    config = function()
      local keymap = require'utils'.keymap{ noremap = true, silent = true }
      keymap {
        { 'n', '<C-n>', ':RnvimrToggle<CR>' },
      }
    end
  } -- File explorer
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require'indent_blankline'.setup {
        char = '│',
        use_treesitter = true,
        show_current_context = true,
        buftype_exclude = { 'terminal' },
        filetype_exclude = { 'help' },
      }
    end,
  } -- Indent lines
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup({ '*' }, {
        rgb_fn = true,
        RRGGBBAA = true,
      })
    end,
  }
  -- Keybinding popup
  use {
    "folke/which-key.nvim",
    config = function()
      require('which-key').setup()
    end
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local keymap = require'utils'.keymap{ noremap = true, silent = true }
      keymap {
        { 'n', '<leader>ff', '<cmd>Telescope find_files hidden=true<cr>' },
        { 'n', '<leader>fg', '<cmd>Telescope live_grep<cr>' },
        { 'n', '<leader>fb', '<cmd>Telescope buffers<cr>' },
        { 'n', '<leader>fh', '<cmd>Telescope help_tags<cr>' },
        { 'n', '<leader>fr', '<cmd>lua require("telescope.builtin").file_browser({hidden=true})<cr>' },
      }
      require('telescope').setup{
          defaults = {
              file_ignore_patterns = { '%.git/' },
          },
      }
    end,
  }
  use {
    'github/copilot.vim',
    config = function()
      require'utils'.setopt('g') {
        copilot_filetypes = {
          markdown = true,
        },
      }
    end,
  }
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})
