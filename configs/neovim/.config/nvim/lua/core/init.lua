require("core.options")
require("core.lazy")
require("core.keymaps")

local util = require("util")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
augroup('bufcheck', { clear = true })
augroup("terminal_settings", { clear = true })

if vim.g.colorscheme then
  vim.cmd("colorscheme " .. vim.g.colorscheme)
  if vim.g.colorscheme == "everforest" and vim.g.everforest_transparent == true then
    util.ColorMyPencils(vim.g.colorscheme)
  end
end

if vim.g.everforest_transparent == true then
  autocmd({ "ColorScheme" }, {
    pattern = { "everforest" },
    callback = function()
      util.ColorMyPencils("everforest")
    end
  })
end

autocmd("BufReadPre", {
  desc = "Disable certain functionality on very large files",
  group = augroup("large_buf", { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    vim.b[args.buf].large_buf = (ok and stats and stats.size > vim.g.max_file.size)
        or vim.api.nvim_buf_line_count(args.buf) > vim.g.max_file.lines
  end,
})

-- disable semantic tokens
autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
});

-- auto update the highlight style on colorscheme change
autocmd({ "ColorScheme" }, {
  pattern = { "*" },
  callback = function(ev)
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
  end
})

autocmd("TermEnter", {
  pattern = "*",
  group = "terminal_settings",
  desc = "Start terminal in insert mode",
  callback = function() vim.cmd("startinsert") end,
})

-- Return to last edit position when opening files
autocmd('BufReadPost', {
  group    = 'bufcheck',
  pattern  = '*',
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos('.', vim.fn.getpos("'\""))
      -- vim.cmd('normal zz') -- how do I center the buffer in a sane way??
      vim.cmd('silent! foldopen')
    end
  end
})

-- Highlight when yanking
autocmd('TextYankPost', {
  group = augroup('HighlightYank', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close with q
autocmd("FileType", {
  group = augroup("close-with-q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(data)
    vim.bo[data.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = data.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- auto open toggleterm
autocmd({ "BufWinEnter" }, {
  group = augroup("nvimtree_and_toggleterm", { clear = true }),
  once = true,
  pattern = "*.*",
  callback = function(data)
    -- buffer is help
    local is_help = vim.bo[data.buf].buftype == "help"

    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    if not real_file and not no_name then
      return
    elseif is_help then
      return
    end

    local auto_nvimtree = vim.fn.has("nvim-tree") and vim.g.auto_open_nvimtree
    local auto_toggleterm = vim.fn.has("toggleterm") and vim.g.auto_open_toggleterm

    if vim.fn.argc() <= 0 then
      if auto_nvimtree and auto_toggleterm then
        util.toggle_nvimtree_and_toggleterm()
      elseif auto_nvimtree and not auto_toggleterm then
        require("nvim-tree.api").tree.find_file({ open = true, focus = false })
      elseif auto_toggleterm and not auto_nvimtree then
        require("toggleterm").toggle()
        vim.cmd("stopinsert")
        vim.cmd("wincmd k")
      else
        require("nvim-tree.api").tree.find_file({ open = true, focus = false })
        require("nvim-tree.api").tree.close()
      end
    elseif auto_nvimtree and auto_toggleterm then
      require("toggleterm").toggle()
      vim.cmd("stopinsert")
      vim.cmd("wincmd k")
      require("nvim-tree.api").tree.close()
      require("nvim-tree.api").tree.find_file({ open = true, focus = false })
      -- vim.cmd("stopinsert")
      -- vim.cmd("wincmd k")
    elseif auto_nvimtree and not auto_toggleterm then
      require("nvim-tree.api").tree.close()
      require("nvim-tree.api").tree.find_file({ open = true, focus = false })
    elseif auto_toggleterm and not auto_nvimtree then
      require("toggleterm").toggle()
      vim.cmd("stopinsert")
      vim.cmd("wincmd k")
    else
      return
    end
  end
})

autocmd("VimEnter", {
  desc = "Focus file buffer on startup",
  group = augroup("alpha_autostart", { clear = true }),
  callback = function()
    local should_skip
    if
        vim.fn.argc() > 0
    then
      vim.cmd("wincmd l")
      vim.cmd("wincmd k")
      should_skip = true
    else
      for _, arg in pairs(vim.v.argv) do
        if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
          should_skip = true
          break
        end
      end
    end
    if should_skip then return end
  end,
})

-- if vim.g.auto_open_nvimtree == true and vim.g.auto_open_toggleterm == false then
--   -- auto open nvim-tree from alpha.nvim
--   autocmd("FileType", {
--     group = augroup("nvimtree_auto", { clear = true }),
--     once = true,
--     pattern = "alpha",
--     callback = function()
--       autocmd("BufReadPre", {
--         once = true,
--         pattern = "*.*",
--         callback = function()
--           if vim.fn.has("nvim-tree") then
--             require("nvim-tree.api").tree.close()
--             require("nvim-tree.api").tree.find_file({ open = true, focus = false })
--             -- vim.cmd("wincmd l")
--           end
--         end,
--       })
--     end,
--   })
-- end
