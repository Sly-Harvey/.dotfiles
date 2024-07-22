local direction = "float"

if vim.g.auto_open_toggleterm == true then direction = "horizontal" end

return {
  "akinsho/toggleterm.nvim",
  event = { "BufReadPost", "UIEnter", "BufNewFile" },
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    -- highlights = {
    --   Normal = { link = "Normal" },
    --   NormalNC = { link = "NormalNC" },
    --   NormalFloat = { link = "NormalFloat" },
    --   FloatBorder = { link = "FloatBorder" },
    --   StatusLine = { link = "StatusLine" },
    --   StatusLineNC = { link = "StatusLineNC" },
    --   WinBar = { link = "WinBar" },
    --   WinBarNC = { link = "WinBarNC" },
    -- },
    on_open = function()
      vim.cmd("startinsert!")
    end,
    size = function(term)
      if term.direction == "horizontal" or term.direction == "float" then
        return 10
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    on_create = function()
      vim.opt.foldcolumn = "0"
      vim.opt.signcolumn = "no"
    end,
    start_in_insert = true,
    shading_factor = 2,
    direction = direction, -- Options: horizontal, float, vertical, tab
    float_opts = { border = "rounded", width = 155, height = 35 },
  },
}
