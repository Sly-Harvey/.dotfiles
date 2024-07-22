return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "InsertEnter" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  config = function()
    require 'nvim-treesitter.configs'.setup({
      -- A list of parser names, or "all"
      ensure_installed = { "c", "lua", "rust", "cpp", "vim", "python", "toml", "yaml" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true,
      },
      context_commentstring = { enable = true, enable_autocmd = true },
      incremental_selection = { enable = true },
    })
  end
}
