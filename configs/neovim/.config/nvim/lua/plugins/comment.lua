return {
    'numToStr/Comment.nvim',
    opts = {
        toggler = {
            ---Line-comment toggle keymap
            line = '<leader>cl',
            ---Block-comment toggle keymap
            block = '<leader>cb',
        }, -- add any options here
        opleader = {
            ---Line-comment keymap
            line = '<leader>cl',
            ---Block-comment keymap
            block = '<leader>cb',
        },
        extra = {
            ---Add comment on the line above
            above = '<leader>clO',
            ---Add comment on the line below
            below = '<leader>clo',
            ---Add comment at the end of line
            eol = '<leader>cla',
        },
    },
    lazy = false,
}
