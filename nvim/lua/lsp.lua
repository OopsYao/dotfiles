-- LSP
-- for lspconfig doc see `:h lspconfig`

-- If global variable `disable_latex_format` exists,
-- then set `disable_format` variable for tex buffers.
-- Should goes before other LspAttach autocommands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("Disable LaTeX formatting", {}),
  pattern = { "*.tex" },
  callback = function(ev)
    if vim.g.disable_latex_format then
      vim.api.nvim_buf_set_var(ev.buf, "disable_format", true)
    end
  end,
})

local aug_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
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
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
    end
    if client.supports_method "textDocument/rename" then
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
    end
    if client.supports_method "textDocument/references" then
      vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
    end

    -- Formatting
    local function setup_formatting_keymap(m)
      vim.keymap.set(m, "<leader>fm", function()
        vim.lsp.buf.format { async = true, buffer = bufnr }
      end, { silent = true, desc = "Format code (async)", buffer = bufnr })
    end
    if client.supports_method "textDocument/rangeFormatting" then
      setup_formatting_keymap "v"
    end
    if client.supports_method "textDocument/formatting" then
      -- Check if buffer variable disable_format exists
      local status, formatting_disabled = pcall(function()
        return vim.api.nvim_buf_get_var(bufnr, "disable_format")
      end)
      formatting_disabled = formatting_disabled and status
      if not formatting_disabled then
        setup_formatting_keymap "n"
        -- Formatting on save
        vim.api.nvim_clear_autocmds { group = aug_formatting, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = aug_formatting,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { timeout_ms = 5000 }
          end,
        })
      end
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
      -- Honor the flake8 config
      -- https://github.com/python-lsp/python-lsp-server#configuration
      configurationSources = { "flake8" },
    },
  },
  capabilities = capabilities,
}

nvim_lsp.efm.setup {
  init_options = { documentFormatting = true },
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
nvim_lsp.lua_ls.setup {
  capabilities = capabilities,
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
