-- Colorscheme based on auto background setting event
local setg = require'utils'.setopt('g')
colo = (function()
    local init = true
    return function(mode)
        if (mode == 'light') then
            require('github-theme').setup{ theme_style = 'light' }
            -- Seems like the github theme will break colors of indent blank line
            vim.cmd[[
              hi IndentBlanklineContextChar guifg=#3b4261
              hi IndentBlanklineChar guifg=#e8e8e8
            ]]
            if (init) then
                setg { airline_theme = 'onehalflight' }
                init = false
            else
                vim.cmd 'AirlineTheme onehalflight'
            end
        else
            vim.cmd 'colo tokyonight' -- dark theme
            vim.g.tokyonight_style = 'storm'
            if (init) then
                setg { airline_theme = 'dracula' }
                init = false
            else
                vim.cmd 'AirlineTheme dracula'
            end
        end
    end
end)()

-- Determine dark/light before the terminal passes info
-- Also serves as fallback if the terminal doesnot provide dark/light info
local f = io.open(os.getenv('HOME') .. '/.DARK_MODE', 'r')
if f ~= nil then
    io.close(f)
    colo 'dark'
else
    colo 'light'
end

-- By default, nvim will check if the terminal is in light mode, and change
-- vim.o.background. (Triggers an event, if it is in dark mode already, nothing happens)
vim.cmd 'au OptionSet background :lua colo(vim.o.bg)'
