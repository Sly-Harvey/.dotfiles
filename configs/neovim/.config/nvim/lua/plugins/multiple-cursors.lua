return {
    "brenton-leighton/multiple-cursors.nvim",
    commit = "e51956b3fb5ddfa8d61cad424002f87bcb59026d",
    opts = {
        enable_split_paste = true,
        match_visible_only = false,
    },
    keys = {
        {"<CA-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i"}},
        {"<CA-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i"}},
        {"<CA-j>", "<Cmd>MultipleCursorsAddDown<CR>"},
        {"<CA-k>", "<Cmd>MultipleCursorsAddUp<CR>"},
        {"<CA-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}},
        {"<Leader>a", "<Cmd>MultipleCursorsAddToWordUnderCursor<CR>", mode = {"n", "v"}},
    },
}
