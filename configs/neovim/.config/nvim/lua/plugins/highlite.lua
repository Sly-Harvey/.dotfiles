return {
    "Iron-E/nvim-highlite",
    event = "UIEnter",
    config = function()
        local allow_list = { __index = function() return false end }
        -- require('highlite.export').nvim("kanagawa", {dir="~/nvim_colorschemes", filename="kanagawa"})
        require('highlite').setup {
            generator = {
                plugins = {
                    nvim = { packer = false },       -- use all but packer
                },
                syntax = setmetatable({ man = true }, allow_list), -- only use `man` sytnax highlighting
            },
        }
    end
}
