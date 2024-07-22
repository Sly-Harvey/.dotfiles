return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    ft = { "gitcommit", "diff" },
    config = function() require('gitsigns').setup() end,
    dependencies = {
      'tpope/vim-fugitive',
      'tpope/vim-rhubarb',
    },
}