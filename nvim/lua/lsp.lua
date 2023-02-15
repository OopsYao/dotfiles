-- LSP
-- for lspconfig doc see `:h lspconfig`
local on_attach = function(client, bufnr)
  -- https://github.com/neovim/nvim-lspconfig/issues/1891#issuecomment-1157964108
  if client.server_capabilities.documentFormattingProvider then
    -- Format by shortcut
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format { async = true, buffer = bufnr }
    end, { silent = true, desc = "Format code (async)" })

    -- Format on close
    local id = vim.api.nvim_create_augroup("Format", {})
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      group = id,
      callback = function()
        -- The callback takes an argument,
        -- so setting callback = vim.lsp.buf.format will not work.
        -- :h lua-guide-autocommands-create
        vim.lsp.buf.format()
      end,
    })
  end
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
  on_attach = function(client, bufnr)
    -- Disable formatting, use efm instead
    -- Texlab rewrites buffer even without changes, still not sure why
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
  end,
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
}

-- Lua
nvim_lsp.lua_ls.setup {
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
