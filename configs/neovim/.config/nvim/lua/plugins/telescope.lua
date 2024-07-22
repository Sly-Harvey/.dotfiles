return {
  'nvim-telescope/telescope.nvim',
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "chip/telescope-software-licenses.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")
    local util = require("util")
    local layout = require("telescope.actions.layout")

    local function vmultiple(prompt_buffer, cmd)
      local picker = actions_state.get_current_picker(prompt_buffer)
      local selections = picker:get_multi_selection()
      local entry = actions_state.get_selected_entry()

      actions.close(prompt_buffer)
      if #selections < 2 then
        vim.cmd[cmd](vim.split(entry.value, ":", { plain = true })[1])
      else
        for _, selection in ipairs(selections) do
          vim.cmd[cmd](vim.split(selection.value, ":", { plain = true })[1])
        end
      end
    end

    require('telescope').setup({
      dynamic_preview_title = true,
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "   ",
        entry_prefix = "    ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.6,
            results_width = 0.7,
          },
          vertical = { mirror = true },
          width = 0.9,
          height = 0.9,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        -- border = {},
        -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,

        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<S-j>"] = actions.move_selection_next,
            ["<S-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },

        file_ignore_patterns = {
          "steam",
          ".git",
          "node_modules",
          "venv",
          ".venv",
          "dosdevices",
          "drive_c",
          "compatdata",
          "cargo",
          ".conan",
          "gem",
          "Brave",
          ".paradox-launcher",
          ".cache",
          "Trash",
          "unity3d",
          "Paradox Interactive",
          "autostart",
          "pulse",
          "droidcam",
          "swap",
          "kdeconnect",
          "OpenTabletDriver",
          ".icons",
          "downloads",
          "secret",
          ".librewolf",
          "kernel",
          "dic",
          "vivaldi",
          "krita",
          "mime",
          "chromium",
          "inkscape",
          "syncthing",
          "xournalpp",
          ".ssh",
          "feh",
          "discord",
          "BetterDiscord",
          "lutris",
          "secrets",
          ".var",
          "pictures",
          "easyeffects",
          ".android",
          ".cmake",
          ".dotnet",
          ".nuget",
          ".vnc",
          ".themes",
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          }
        }
      },
      pickers = {
        buffers = {
          sort_lastused = true,
          prompt_prefix = "   ",
          previewer = false,

          layout_config = {
            width = 0.3,
            height = 0.4,
          },
          mappings = {
            ["i"] = {
              ["<C-D>"] = actions.delete_buffer + actions.move_to_top,
            },
            ["n"] = {
              ["v"] = function(prompt_buffer) vmultiple(prompt_buffer, "vsplit") end,
              ["dd"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
        find_files = {
          no_ignore = true,
          hidden = true,
          prompt_prefix = "   ",
          mappings = {
            ["i"] = {
              ["<C-Space>"] = function(prompt_buffer)
                actions.close(prompt_buffer)
                vim.ui.input({ prompt = "glob patterns(comma sep): " }, function(input)
                  if not input then return end
                  require("telescope.builtin").find_files({
                    file_ignore_patterns = vim.split(vim.trim(input), ",", { plain = true }),
                  })
                end)
              end,
            },
            ["n"] = {
              ["v"] = function(prompt_buffer) vmultiple(prompt_buffer, "vsplit") end,
              ["p"] = layout.toggle_preview,
            },
          },
        },
        oldfiles = {
          prompt_prefix = "   ",
        },
        colorscheme = {
          prompt_prefix = "   ",
        },
        highlights = {
          prompt_prefix = " קּ  ",
        },
        live_grep = {
          prompt_prefix = "   ",
          mappings = {
            ["i"] = {
              ["<C-S>"] = function(prompt_buffer)
                local current_picker = actions_state.get_current_picker(prompt_buffer)
                local previewers = current_picker.all_previewers
                local current_previewer_index = current_picker.current_previewer_index
                local current_previewer = previewers[current_previewer_index]
                local previewer_buffer = current_previewer.state.bufnr
                vim.api.nvim_buf_set_option(previewer_buffer, "filetype", "")
              end,
              ["<C-p>"] = layout.toggle_preview,
            },
            ["n"] = {
              ["v"] = function(prompt_buffer) vmultiple(prompt_buffer, "vsplit") end,
              ["V"] = function(prompt_buffer) vmultiple(prompt_buffer, "edit") end,
            },
          },
        },
        git_commits = {
          prompt_prefix = " ﰖ  ",
        },
        git_bcommits = {
          prompt_prefix = " ﰖ  ",
        },
        git_branches = {
          prompt_prefix = " שׂ  ",
        },
        git_status = {
          prompt_prefix = "   ",
          git_icons = {
            added = "+",
            changed = "~",
            copied = ">",
            deleted = "-",
            renamed = "➡",
            unmerged = "‡",
            untracked = "?",
          },
        },
        git_files = {
          prompt_prefix = " שׂ  ",
        },
        commands = {
          prompt_prefix = "   ",
        },
        registers = {
          prompt_prefix = "   ",
        },
        spell_suggests = {
          prompt_prefix = "   ",
        },
        keymaps = {
          prompt_prefix = "   ",
        },
        lsp_code_actions = {
          prompt_prefix = "   ",
          theme = "cursor",
        },
        lsp_references = {
          prompt_prefix = "   ",
        },
        lsp_implementations = {
          prompt_prefix = "   ",
        },
        lsp_document_diagnostics = {
          prompt_prefix = " 律 ",
        },
      },
    })
    require('telescope').load_extension('projects')
    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("software-licenses")
  end,
}
