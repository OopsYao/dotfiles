local module = {}

function module.keymap(opts)
    -- Recieves a table as options for keymapping, and returns a
    -- function that receives a table of keymappings to set.
  return function(config)
    for _, v in pairs(config) do
      local mode, key, action = unpack(v)
      -- About the keymap settings, see :h lua-guide-mappings
      vim.keymap.set(mode, key, action, opts)
    end
  end
end

function module.setopt(field)
  local opt = vim[field]
  return function(config)
    for k, v in pairs(config) do
      opt[k] = v
    end
  end
end

return module
