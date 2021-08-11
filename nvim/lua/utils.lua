module = {}

function module.keymap(opts)
  local set_keymap = vim.api.nvim_set_keymap
  return function(config)
           for _, v in pairs(config) do
             local mode = v[1]
             local key = v[2]
             local action = v[3]
             set_keymap(mode, key, action, opts)
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
