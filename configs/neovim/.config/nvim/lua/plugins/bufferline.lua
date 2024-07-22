return {
  'akinsho/bufferline.nvim',
  version = "*",
  event = "BufReadPre", --WinNew
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local status, bufferline = pcall(require, "bufferline")
    if not status then
      print("ERROR bufferline")
      return
    end

    bufferline.setup({
      options = {
        offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "left", } }, -- padding = 1 (optional)
        separator_style = "thin",
        indicator_icon = "▎",
        modified_icon = "●",
        buffer_close_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        numbers = "ordinal",
        max_name_length = 15, --default 15
        max_prefix_length = 6, -- default 6
        tab_size = 21,
        diagnostics = true, -- | "nvim_lsp" | "coc", default = nvim_lsp
        diagnostics_update_in_insert = false,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = true,
        persist_buffer_sort = true,
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and "" or ""
          return icon .. count
        end,
      },
    })
  end
}
