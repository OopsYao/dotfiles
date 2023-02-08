-- Colorscheme based on auto background setting event
colo = (function()
  local init = true
  return function(mode)
    if mode ~= "dark" and mode ~= "light" then
      local f = io.open(os.getenv "HOME" .. "/.DARK_MODE", "r")
      if f ~= nil then
        io.close(f)
        mode = "dark"
      else
        mode = "light"
      end
    end

    vim.g.colors_name = nil
    if mode == "light" then
      vim.o.bg = "light"
      require("github-theme").setup { theme_style = "light_default" }
    else
      vim.o.bg = "dark"
      vim.g.tokyonight_style = "storm"
      vim.cmd "colo tokyonight" -- dark theme
    end
    vim.cmd "syn on"
  end
end)()

colo "dark"
