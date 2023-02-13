vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
require("packer").startup {
  function(use)
    use {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        vim.cmd.colorscheme "catppuccin"
      end,
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require "lsp"
      end,
    }
    use {
      "hrsh7th/nvim-cmp",
      config = function()
        vim.o.completeopt = "menuone,noselect"
        local cmp = require "cmp"
        cmp.setup {
          sources = {
            { name = "nvim_lsp" },
          },
          mapping = cmp.mapping.preset.insert {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<CR>"] = cmp.mapping.confirm { select = true },
          },
        }
      end,
      requires = { "hrsh7th/cmp-nvim-lsp" },
    } -- Auto completion
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup {
          highlight = {
            enable = true,
          },
        }
      end,
    }
    use {
      "terrortylor/nvim-comment",
      branch = "main",
      config = function()
        require("nvim_comment").setup()
      end,
    } -- Comment
    use {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup {
          -- Due to the limitation of nvim, there is no perfect way
          -- to display gitsigns and dignostic marks at the same time,
          -- hence display gitsigns only if both activated.
          sign_priority = 100,
          current_line_blame = true,
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end
            map("n", "<leader>hp", gs.preview_hunk)
            map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
            map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
            map("n", "<leader>hu", gs.undo_stage_hunk)
            map("n", "<leader>hS", gs.stage_buffer)
            map("n", "<leader>hR", gs.reset_buffer)
          end,
        }
      end,
    }
    use "psliwka/vim-smoothie" -- Smooth scrolling
    use {
      "romgrk/barbar.nvim",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        local keymap = require("utils").keymap { noremap = true, silent = true }
        keymap {
          { "n", "<A-h>", ":BufferPrevious<CR>" },
          { "t", "<A-h>", "<C-\\><C-n>:BufferPrevious<CR>" },
          { "n", "<A-l>", ":BufferNext<CR>" },
          { "t", "<A-l>", "<C-\\><C-n>:BufferNext<CR>" },
          { "n", "<A-x>", ":BufferClose<CR>" },
          { "t", "<A-x>", "<C-\\><C-n>:BufferClose<CR>" },
          { "n", "<C-s>", ":BufferPick<CR>" }, -- Buffer-picking mode
          { "t", "<C-s>", "<C-\\><C-n>:BufferPick<CR>" },
        }
        vim.g.bufferline = {
          auto_hide = true,
        }
      end,
    }
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup {
          char = "│",
          use_treesitter = true,
          show_current_context = true,
          buftype_exclude = { "terminal" },
          filetype_exclude = { "help" },
        }
      end,
    } -- Indent lines
    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({ "*" }, {
          rgb_fn = true,
          RRGGBBAA = true,
        })
      end,
    }
    -- Keybinding popup
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup()
      end,
    }
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
      },
      config = function()
        local keymap = require("utils").keymap { noremap = true, silent = true }
        keymap {
          { "n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>" },
          { "n", "<leader>fg", "<cmd>Telescope live_grep<cr>" },
          { "n", "<leader>fb", "<cmd>Telescope buffers<cr>" },
          { "n", "<leader>fh", "<cmd>Telescope help_tags<cr>" },
          { "n", "<leader>fr", "<cmd>Telescope file_browser<cr>" },
        }
        require("telescope").setup {
          defaults = {
            file_ignore_patterns = { "%.git/" },
          },
        }
        require("telescope").load_extension "file_browser"
      end,
    }
    use {
      "github/copilot.vim",
      config = function()
        require("utils").setopt "g" {
          copilot_filetypes = {
            markdown = true,
          },
        }
      end,
    }
    use {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
    }
    use {
      "folke/zen-mode.nvim",
      config = function()
        require("zen-mode").setup {}
      end,
    }
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
  },
}
