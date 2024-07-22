return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    event = "UIEnter",
    config = function()
        require('kanagawa').setup({
            transparent = false,
            colors = {
                -- palette = {
                --     sumiInk3 = "#181818",
                --     waveBlue1 = "#16161D",
                --     waveBlue2 = "#3D484D",
                -- },
                theme = {
                    -- change specific usages for a certain theme, or for all of them
                    all = {
                        ui = {
                            bg_gutter = "none"
                        }
                    }
                }
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
        })
    end
}
