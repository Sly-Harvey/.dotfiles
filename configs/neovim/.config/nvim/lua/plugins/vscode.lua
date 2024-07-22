-- Lua:
-- For dark theme (neovim's default)
-- vim.o.background = 'dark'
-- For light theme
-- vim.o.background = 'light'

return {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    event = "UIEnter",
    config = function()
        local c = require('vscode.colors').get_colors()
        require('vscode').setup({
            -- Alternatively set style in setup
            style = 'dark',

            -- Enable transparent background
            transparent = false,

            -- Enable italic comment
            italic_comments = true,

            -- Disable nvim-tree background color
            disable_nvimtree_bg = true,

            -- Override colors (see ./lua/vscode/colors.lua)
            color_overrides = {
                --vscLineNumber = '#FFFFFF',
                vscRed = '#9CDCFE',
            },

            -- Override highlight groups (see ./lua/vscode/theme.lua)
            group_overrides = {
                -- this supports the same val table as vim.api.nvim_set_hl
                -- use colors from this colorscheme by requiring vscode.colors!
                LineNr = { fg = '#858585', bg = c.vscBack },
                CursorLineNr = { fg = '#C6C6C6', bg = c.vscBack },
                Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
                Comment = { fg = c.vscGreen, bg ='NONE', italic = true }
            }
        })
        --require('vscode').load()
    end
}
