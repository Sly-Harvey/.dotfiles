return {
    'goolord/alpha-nvim',
    event = "VimEnter",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local status_ok, alpha = pcall(require, "alpha")
        if not status_ok then
            return
        end

        local dashboard = require("alpha.themes.dashboard")

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            desc = "Add Alpha dashboard footer",
            once = true,
            callback = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime * 100 + 0.5) / 100 --*.2f
                dashboard.section.footer.val = { "Neovim loaded " .. stats.loaded .. " plugins  in " .. ms .. "ms" }
                pcall(vim.cmd.AlphaRedraw)
            end,
        })

        dashboard.section.buttons.val = {
            dashboard.button("ff", "󰈞  Find file", ":Telescope find_files <CR>"),
            dashboard.button("fn", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("fr", "󰊄  Recently used files", ":Telescope oldfiles <CR>"),
            dashboard.button("fg", "󰈬  Live grep", ":Telescope live_grep <CR>"),
            dashboard.button("cf", "  Configuration", ":e " .. vim.fn.stdpath("config") .. "<CR>"),
            dashboard.button("pm", "  Plugin manager", ":Lazy<CR>"),
            dashboard.button("qn", "󰅚  Quit Neovim", ":qa<CR>"),
        }

        -- define startup ascii art here.
        --dashboard.section.header.val = {  }

        alpha.setup(dashboard.opts)
    end,
}
