return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    event = "UIEnter",
    config = function()
        require("catppuccin").setup({
            style = "night",
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {         -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false, -- disables setting the background color.
            show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
            color_overrides = {},
            custom_highlights = {},
            integrations = {
                alpha = true,
                hop = true,
                dap = true,
                dap_ui = true,
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                mini = false,
                telescope = {
                    enabled = true,
                    -- style = "nvchad"
                },
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })
    end
}
