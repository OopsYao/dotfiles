local module = {}

local function merge(t1, t2)
  -- Merge tables t2 and t1, use value of t2 if key is present in both.
  local t = {}
  t1 = t1 or {}
  t2 = t2 or {}
  for k, v in pairs(t1) do
    t[k] = v
  end
  for k, v in pairs(t2) do
    t[k] = v
  end
  return t
end

function module.keymap(opts)
  -- Recieves a table as options for keymapping, and returns a
  -- function that receives a table of keymappings to set.
  return function(config)
    for _, v in pairs(config) do
      local mode, key, action, indi_opts = unpack(v)
      -- About the keymap settings, see :h lua-guide-mappings
      vim.keymap.set(mode, key, action, merge(opts, indi_opts))
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
