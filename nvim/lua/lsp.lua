-- Enable auto complete
vim.o.completeopt = 'menuone,noselect'
require'compe'.setup {
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
  },
}

-- LSP
-- for lspconfig doc see `:h lspconfig`
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end
local nvim_lsp = require'lspconfig'

nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  settings = {
    pylsp = {
      -- Honor the flake8 config
      -- https://github.com/python-lsp/python-lsp-server#configuration
      configurationSources = {'flake8'},
    }
  }
}

nvim_lsp.tsserver.setup {
  on_attach = function(client, ...)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, ...)
  end
}

local fts = { 'javascript', 'vue', 'css', 'scss', 'lua' }
nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = fts,
  init_options = {
    formatFiletypes = (function()
      local t = {}
      for _, ft in ipairs(fts) do
        t[ft] = 'prettier'
        if ft == 'lua' then
            t[ft] = 'luaformatter'
        end
      end
      return t
    end)(),
    formatters = {
      prettier = {
        command = 'npx',
        args = { 'prettier', '--stdin-filepath', '%filepath' },
      },
      luaformatter = {
        command = 'lua-format',
        args = { '%filepath' },
      },
    },
  }
}
