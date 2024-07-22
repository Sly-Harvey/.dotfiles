return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    'williamboman/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    'glepnir/lspsaga.nvim',
  },
  config = function()
    -- Configure code warnings such as unused variables
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = true, -- False to disable sign icons.
      virtual_text = true, -- False to disable virtual_text.
      underline = false, -- False to disable code warnings.
      update_in_insert = true,
    }
    )

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "rust_analyzer", "clangd"},
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    local lspconfig = require("lspconfig")

    local saga = require("lspsaga")
    saga.init_lsp_saga = {
      code_action_prompt = { enable = true, },
    }

    --vim.keymap.set("n", "gd", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
    --vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<cr>', { silent = true })
    --vim.keymap.set({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
    vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })

    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.stdpath "config" .. "/lua"] = true,
            },
          },
        },
      }
    }
    lspconfig.pyright.setup {
      capabilities = capabilities,
    }

    lspconfig.cmake.setup {
      capabilities = capabilities,
    }

    lspconfig.rnix.setup {
      capabilities = capabilities,
    }

    lspconfig.nil_ls.setup {
      capabilities = capabilities,
    }

    lspconfig.clangd.setup {
      capabilities = capabilities,
    }

    lspconfig.omnisharp.setup {
      capabilities = capabilities,
    }

    lspconfig.solargraph.setup {
      capabilities = capabilities,
    }
  end
}
