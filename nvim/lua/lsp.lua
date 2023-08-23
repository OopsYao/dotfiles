-- LSP
-- for lspconfig doc see `:h lspconfig`

local aug_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
local function setup_formatting(client, bufnr, blacklist)
  local function format_func(async)
    return function()
      vim.lsp.buf.format {
        buffer = bufnr,
        async = async,
        timeout_ms = 5000,
        filter = function(c)
          for _, n in ipairs(blacklist) do
            if n == c.name then
              return false
            end
          end
          return true
        end,
      }
    end
  end
  local function setup_formatting_keymap(m)
    vim.keymap.set(m, "<leader>fm", format_func(true), { silent = true, desc = "Format code (async)", buffer = bufnr })
  end

  for _, cn in ipairs(blacklist) do
    if cn == client.name then
      return
    end
  end

  if client.supports_method "textDocument/rangeFormatting" then
    setup_formatting_keymap "v"
  end

  -- Formatting on save and hotkey
  if client.supports_method "textDocument/formatting" then
    for _, ft in ipairs(vim.g.disable_formatting_types or {}) do
      if ft == vim.bo.filetype then
        return
      end
    end

    setup_formatting_keymap "n"
    vim.api.nvim_clear_autocmds { group = aug_formatting, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = aug_formatting,
      buffer = bufnr,
      callback = format_func(false),
    })
  end
end

local function on_demand_setting(name)
  local disable_tex_lint = vim.tbl_contains(vim.g.disable_lint_types or {}, "tex")
  local settings = {
    ltex = {
      language = vim.g.my_ltex_language or "en-US",
    },
    texlab = {
      chktex = {
        onEdit = not disable_tex_lint,
        onOpenAndSave = not disable_tex_lint,
      },
    },
  }
  if settings[name] then
    return { [name] = settings[name] }
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- See https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textdocumentclientcapabilities
    -- for all valid capabilities.
    -- Note that `client.supports_method` always return `true` for unknown capabilities.
    -- https://github.com/neovim/neovim/issues/18686#issuecomment-1133804806
    if client.supports_method "textDocument/codeAction" then
      vim.keymap.set({ "n", "v" }, "<leader>ac", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
    end
    if client.supports_method "textDocument/rename" then
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
    end
    if client.supports_method "textDocument/references" then
      vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
    end

    -- Formatting
    -- Texlab rewrites buffer with extra endline on every formatting, not sure why
    setup_formatting(client, bufnr, { "texlab" })

    -- On-demand setting
    local settings = on_demand_setting(client.name)
    if settings ~= nil then
      -- Seems like that notification `workspace/didChangeConfiguration` doesnot work,
      -- while reassigning settings does the job.
      -- https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings#configure-in-your-personal-settings-initlua
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, settings)
    end
  end,
})

-- Language server provide different completion results depending on the
-- capabilities of the client. Besides the LSP source for nvim-cmp, cmp-nvim-lsp
-- also provides the capabilities supported by nvim-cmp.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require "lspconfig"

nvim_lsp.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,
          extendSelect = { "I" },
        },
      },
    },
  },
  capabilities = capabilities,
}

nvim_lsp.efm.setup {
  init_options = { documentFormatting = true, documentRangeFormatting = true },
  capabilities = capabilities,
}

-- YAML
nvim_lsp.yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
  capabilities = capabilities,
}

-- LaTeX
local forwardSearch = function(executable)
  local args = {}
  if executable == "zathura" then
    args = {
      "--synctex-editor-command",
      [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
      "--synctex-forward",
      "%l:1:%f",
      "%p",
    }
  elseif executable == "sioyek" then
    args = {
      "--inverse-search",
      [[nvim-texlabconfig -file %%%1 -line %%%2 -server ]] .. vim.v.servername,
      "--forward-search-file",
      "%f",
      "--forward-search-line",
      "%l",
      "%p",
    }
  end
  return {
    executable = executable,
    args = args,
  }
end

nvim_lsp.texlab.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Disable formatting, use efm instead
    -- Texlab rewrites buffer even without changes, still not sure why
    client.server_capabilities.documentFormattingProvider = false
    vim.keymap.set(
      "n",
      "<leader>s",
      "<cmd>TexlabForward<cr>",
      { buffer = bufnr, silent = true, desc = "SyncTeX forward search" }
    )
  end,
  settings = {
    texlab = {
      build = {
        onSave = true,
        forwardSearchAfter = true, -- Do forward search after build
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = true,
      },
      forwardSearch = forwardSearch "sioyek",
    },
  },
}

-- Lua
local pwd = vim.fn.getcwd()
local global_awesomewm = pwd:match "%.dotfiles$" and { "awesome", "client", "root", "screen" } or {}

nvim_lsp.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = vim.tbl_extend("force", { "vim" }, global_awesomewm),
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- Do not prompt for working environment
        -- https://github.com/neovim/nvim-lspconfig/issues/1700
        checkThirdParty = false,
      },
      format = {
        -- https://github.com/LuaLS/lua-language-server/wiki/Formatter
        -- Custom config doesnot work, use stylua via efm instead
        enable = false,
      },
    },
  },
}

nvim_lsp.ltex.setup {
  on_attach = function()
    require("ltex_extra").setup {
      -- Default dictionary to be loaded issue
      -- https://github.com/barreiroleo/ltex_extra.nvim/issues/43#issue-1815257892
      load_langs = { "en-US", "zh-CN" },
    }
  end,
  settings = {
    ltex = {
      latex = {
        environments = {
          empheq = "ignore",
        },
      },
    },
  },
}
