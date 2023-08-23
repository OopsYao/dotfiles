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
      "glepnir/dashboard-nvim",
      event = "VimEnter",
      config = function()
        require("dashboard").setup {}
      end,
      requires = { "nvim-tree/nvim-web-devicons" },
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require "lsp"
      end,
    }
    use {
      "L3MON4D3/LuaSnip",
      config = function()
        require "snippets"
      end,
    }
    use {
      "hrsh7th/nvim-cmp",
      config = function()
        vim.o.completeopt = "menuone,noselect"
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end
        local function super_tab(fallback)
          -- This will be called even not selected if the snippet trigger matches.
          -- In other words, cmp.confirm calls luasnip.expand internally.
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          elseif fallback ~= nil then
            fallback()
          end
        end

        cmp.setup {
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          sources = cmp.config.sources({
            { name = "luasnip" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "latex_symbols" },
            { name = "emoji" },
            { name = "nerdfont" },
          }, {
            { name = "buffer" },
            { name = "async_path" },
          }),
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<CR>"] = cmp.mapping(function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm { select = true }
              else
                fallback()
              end
            end),
            ["<Tab>"] = cmp.mapping(super_tab, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end),
          },
          formatting = {
            format = require("lspkind").cmp_format {},
          },
        }
        -- Seems like that nvim-cmp doesnot support mapping in normal mode
        vim.keymap.set("n", "<Tab>", super_tab)
      end,
      -- cmp-nvim-lsp provides the LSP source
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
        "FelipeLema/cmp-async-path",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-omni",
        "hrsh7th/cmp-emoji",
        "chrisgrieser/cmp-nerdfont",
        "kdheepak/cmp-latex-symbols",
      },
    } -- Auto completion
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup {
          highlight = {
            enable = true,
          },
          indent = {
            -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
            disable = { "python" },
          },
        }
      end,
    }
    use "nvim-treesitter/playground"
    use {
      -- Auto pairs
      "windwp/nvim-autopairs",
      config = function()
        local npairs = require "nvim-autopairs"
        npairs.setup {}
        local Rule = require "nvim-autopairs.rule"
        npairs.add_rules {
          Rule("\\(", "\\)", "tex"),
          Rule("\\[", "\\]", "tex"),
          Rule("\\left(", "\\right)", "tex"),
          Rule("\\left[", "\\right]", "tex"),
          Rule("\\left\\{", "\\right\\}", "tex"),
          Rule("\\langle", "\\rangle", "tex"),
          Rule("\\lvert", "\\rvert", "tex"),
          Rule("\\lVert", "\\rVert", "tex"),
          Rule("\\(", "\\)", "markdown"),
          Rule("\\[", "\\]", "markdown"),
          Rule("\\left(", "\\right)", "markdown"),
          Rule("\\left[", "\\right]", "markdown"),
          Rule("\\left\\{", "\\right\\}", "markdown"),
          Rule("\\langle", "\\rangle", "markdown"),
          Rule("\\lvert", "\\rvert", "markdown"),
          Rule("\\lVert", "\\rVert", "markdown"),
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
          current_line_blame = true,
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end
            map("n", "<leader>hp", gs.preview_hunk, { desc = "Gitsigns preview hunk" })
            map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage hunk" })
            map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk" })
            map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Gitsigns undo stage hunk" })
            map("n", "<leader>hS", gs.stage_buffer, { desc = "Gitsigns stage buffer" })
            map("n", "<leader>hR", gs.reset_buffer, { desc = "Gitsigns reset buffer" })
            map("n", "]c", function()
              if vim.wo.diff then
                return "]c"
              end
              vim.schedule(gs.next_hunk)
              return "<Ignore>"
            end, { desc = "Gitsigns next hunk", expr = true })
            map("n", "[c", function()
              if vim.wo.diff then
                return "[c"
              end
              vim.schedule(gs.prev_hunk)
              return "<Ignore>"
            end, { desc = "Gitsigns previous hunk", expr = true })
            map("n", "<leader>hd", gs.diffthis, { desc = "Gitsigns diff this" })
          end,
        }
      end,
    }
    use "psliwka/vim-smoothie" -- Smooth scrolling
    use "kyazdani42/nvim-web-devicons"
    use {
      "nvim-lualine/lualine.nvim",
      requires = { "nvim-tree/nvim-web-devicons", opt = true },
      config = function()
        require("lualine").setup {
          options = {
            always_divide_middle = false,
          },
          sections = {
            lualine_a = {},
            lualine_c = {
              {
                "filename",
                path = 1,
                symbols = {
                  modified = "●",
                },
              },
            },
          },
          inactive_sections = {
            lualine_c = {},
            lualine_x = {},
            lualine_a = {
              {
                "filetype",
                icon_only = true,
                separator = "",
                padding = 0,
                symbols = {
                  modified = "●",
                },
              },
            },
            lualine_b = {
              {
                "filename",
                path = 1,
                symbols = {
                  modified = "●",
                },
              },
            },
          },
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
          filetype_exclude = { "help", "dashboard", "packer" },
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
        local telescope = require "telescope"
        telescope.setup {
          defaults = {
            file_ignore_patterns = { "%.git/" },
          },
        }
        telescope.load_extension "file_browser"
        telescope.load_extension "notify"
        local buildin = require "telescope.builtin"
        local keymap = vim.keymap.set
        keymap("n", "<leader>ff", function()
          buildin.find_files { hidden = true }
        end, { desc = "Find files" })
        keymap("n", "<leader>fg", buildin.live_grep, { desc = "Live grep" })
        keymap("n", "<leader>fb", buildin.buffers, { desc = "Buffers" })
        keymap("n", "<leader>fr", telescope.extensions.file_browser.file_browser, { desc = "File browser" })
        keymap("n", "<leader>fs", buildin.git_status, { desc = "Git status" })
        keymap("n", "<leader>dd", buildin.diagnostics, { desc = "Open diagnostics in Telescope" })
        keymap("n", "<leader>pp", function()
          buildin.builtin { include_extensions = true }
        end, { desc = "Show Telescope builtins" })
        keymap("n", "<leader>nt", telescope.extensions.notify.notify, { desc = "Show notifications" })
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
    -- Neovim config for SyncTeX inverse search
    use {
      "f3fora/nvim-texlabconfig",
      config = function()
        require("texlabconfig").setup {}
      end,
      -- Build nvim-texlabconfig executable to plugin dir by default
      -- Must include `nvim-texlabconfig` in path
      run = "go build -o ~/.local/bin",
    }
    use {
      "rcarriga/nvim-notify",
      config = function()
        vim.notify = require "notify"
      end,
    }
    use {
      "barreiroleo/ltex_extra.nvim",
    }
    use {
      "romgrk/barbar.nvim",
      requires = {
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        local function keymap(m, key, func, opts)
          vim.keymap.set(m, key, func, vim.tbl_extend("force", { silent = true }, opts))
        end
        keymap("n", "<A-h>", ":BufferPrevious<CR>", { desc = "Previous buffer" })
        keymap("n", "<A-l>", ":BufferNext<CR>", { desc = "Next buffer" })
        keymap("n", "<A-,>", ":BufferMovePrevious<CR>", { desc = "Move buffer to previous" })
        keymap("n", "<A-.>", ":BufferMoveNext<CR>", { desc = "Move buffer to next" })
        keymap("n", "<A-x>", ":BufferClose<CR>", { desc = "Close buffer" })
      end,
    }
    use {
      "Bekaboo/deadcolumn.nvim",
      config = function()
        vim.wo.colorcolumn = "80"
      end,
    }
    use {
      "sindrets/diffview.nvim",
      requires = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("diffview").setup {
          view = {
            default = {
              layout = "diff2_horizontal",
              winbar_info = true,
            },
          },
          hooks = {
            -- Disable gitsigns sign highlight
            view_enter = function()
              require("gitsigns").toggle_signs(false)
            end,
            view_leave = function()
              require("gitsigns").toggle_signs(true)
            end,
          },
        }
      end,
    }
    use {
      "klen/nvim-config-local",
      config = function()
        require("config-local").setup {}
      end,
    }
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
  },
}
