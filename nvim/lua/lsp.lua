-- LSP
-- for lspconfig doc see `:h lspconfig`
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format{async=true}<CR>', opts)
end
local capabilities = require'cmp_nvim_lsp'.default_capabilities()
local nvim_lsp = require'lspconfig'

nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  settings = {
    pylsp = {
      -- Honor the flake8 config
      -- https://github.com/python-lsp/python-lsp-server#configuration
      configurationSources = {'flake8'},
    }
  },
  capabilities = capabilities,
}

nvim_lsp.efm.setup{
    on_attach = on_attach,
    filetypes = {'lua', 'yaml', 'javascript'},
    capabilities = capabilities,
}

-- YAML
nvim_lsp.yamlls.setup {
    on_attach = on_attach,
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
            },
        },
    },
    capabilities = capabilities,
}

-- LaTeX
require'lspconfig'.texlab.setup {
    on_attach = on_attach,
    settings = {
      texlab = {
        build = {
          args = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
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
