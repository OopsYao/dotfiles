-- LSP
-- for lspconfig doc see `:h lspconfig`
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format{async=true}<CR>", opts)
end
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require "lspconfig"

nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  settings = {
    pylsp = {
      -- Honor the flake8 config
      -- https://github.com/python-lsp/python-lsp-server#configuration
      configurationSources = { "flake8" },
    },
  },
  capabilities = capabilities,
}

nvim_lsp.efm.setup {
  on_attach = on_attach,
  init_options = { documentFormatting = true },
}

-- YAML
nvim_lsp.yamlls.setup {
  on_attach = on_attach,
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
require("lspconfig").texlab.setup {
  on_attach = on_attach,
  settings = {
    texlab = {
      build = {
        onSave = true,
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = true,
      },
    },
  },
  capabilities = capabilities,
}

-- Lua
require("lspconfig").sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
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
