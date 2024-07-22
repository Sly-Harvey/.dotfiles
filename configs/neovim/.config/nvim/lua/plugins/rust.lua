return {
  'simrat39/rust-tools.nvim',
  ft = {
    "rust",
    "toml"
  },
  config = function()
    local rt = require("rust-tools")

    local extension_path = vim.env.HOME .. '/mason/packages/codelldb/extension/'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb'
    local this_os = vim.loop.os_uname().sysname;
    
    if this_os:find "Windows" then
      codelldb_path = extension_path .. "adapter\\codelldb.exe"
      liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
    else
      -- The liblldb extension is .so for linux and .dylib for macOS
      liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    end
    
    -- rust tools opts
    local opts = {
      tools = { -- rust-tools options
    
        -- how to execute terminal commands
        -- options right now: termopen / quickfix / toggleterm / vimux
        executor = require("rust-tools.executors").termopen,
    
        -- callback to execute once rust-analyzer is done initializing the workspace
        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
        on_initialized = nil,
    
        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = true,
    
        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
          -- automatically set inlay hints (type hints)
          -- default: true
          auto = true,
    
          -- Only show inlay hints for the current line
          only_current_line = false,
    
          -- whether to show parameter hints with the inlay hints or not
          -- default: true
          show_parameter_hints = true,
    
          -- prefix for parameter hints
          -- default: "<-"
          parameter_hints_prefix = "<- ",
    
          -- prefix for all the other hints (type, chaining)
          -- default: "=>"
          other_hints_prefix = "=> ",
    
          -- whether to align to the length of the longest line in the file
          max_len_align = false,
    
          -- padding from the left if max_len_align is true
          max_len_align_padding = 1,
    
          -- whether to align to the extreme right or not
          right_align = false,
    
          -- padding from the right if right_align is true
          right_align_padding = 7,
    
          -- The color of the hints
          highlight = "gitcommitComment",
        },
    
        -- options same as lsp hover / vim.lsp.util.open_floating_preview()
        hover_actions = {
          -- the border that is used for the hover window
          -- see vim.api.nvim_open_win()
          border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
          },
    
          -- Maximal width of the hover window. Nil means no max.
          max_width = nil,
    
          -- Maximal height of the hover window. Nil means no max.
          max_height = nil,
    
          -- whether the hover action window gets automatically focused
          -- default: false
          auto_focus = true,
        },
    
        -- settings for showing the crate graph based on graphviz and the dot
        -- command
        crate_graph = {
          -- Backend used for displaying the graph
          -- see: https://graphviz.org/docs/outputs/
          -- default: x11
          backend = "x11",
          -- where to store the output, nil for no output stored (relative
          -- path from pwd)
          -- default: nil
          output = nil,
          -- true for all crates.io and external crates, false only the local
          -- crates
          -- default: true
          full = true,
    
          -- List of backends found on: https://graphviz.org/docs/outputs/
          -- Is used for input validation and autocompletion
          -- Last updated: 2021-08-26
          enabled_graphviz_backends = {
            "bmp",
            "cgimage",
            "canon",
            "dot",
            "gv",
            "xdot",
            "xdot1.2",
            "xdot1.4",
            "eps",
            "exr",
            "fig",
            "gd",
            "gd2",
            "gif",
            "gtk",
            "ico",
            "cmap",
            "ismap",
            "imap",
            "cmapx",
            "imap_np",
            "cmapx_np",
            "jpg",
            "jpeg",
            "jpe",
            "jp2",
            "json",
            "json0",
            "dot_json",
            "xdot_json",
            "pdf",
            "pic",
            "pct",
            "pict",
            "plain",
            "plain-ext",
            "png",
            "pov",
            "ps",
            "ps2",
            "psd",
            "sgi",
            "svg",
            "svgz",
            "tga",
            "tiff",
            "tif",
            "tk",
            "vml",
            "vmlz",
            "wbmp",
            "webp",
            "xlib",
            "x11",
          },
        },
      },
    
      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
      server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
      },
    
      -- debugging stuff
      --dap = {
      --  adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
      --}
    }
    
    require('rust-tools').setup(opts)
  end,
  dependencies = {
    {
      'saecki/crates.nvim',
      config = function()
        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true }
        
        
        local crates = require('crates')
        keymap('n', '<leader>ct', require('crates').toggle, opts)
        keymap('n', '<leader>cr', require('crates').reload, opts)
        keymap('n', '<leader>cv', require('crates').show_versions_popup, opts)
        keymap('n', '<leader>cf', require('crates').show_features_popup, opts)
        keymap('n', '<leader>cd', require('crates').show_dependencies_popup, opts)
        keymap('n', '<leader>cu', require('crates').update_crate, opts)
        keymap('v', '<leader>cu', require('crates').update_crates, opts)
        keymap('n', '<leader>ca', require('crates').update_all_crates, opts)
        keymap('n', '<leader>cU', require('crates').upgrade_crate, opts)
        keymap('v', '<leader>cU', require('crates').upgrade_crates, opts)
        keymap('n', '<leader>cA', require('crates').upgrade_all_crates, opts)
        keymap('n', '<leader>cH', require('crates').open_homepage, opts)
        keymap('n', '<leader>cR', require('crates').open_repository, opts)
        keymap('n', '<leader>cD', require('crates').open_documentation, opts)
        keymap('n', '<leader>cC', require('crates').open_crates_io, opts)
        --keymap('n', '<leader>ce', crates.expand_plain_crate_to_inline_table, opts)
        --keymap('n', '<leader>cE', crates.extract_crate_into_table, opts)
        
        crates.setup()
      end,
    },
  }
}