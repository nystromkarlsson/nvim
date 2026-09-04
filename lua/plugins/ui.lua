local defer = require("defer")

vim.pack.add({
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/nvim-mini/mini.nvim",
}, { confirm = false })

require("tokyonight").setup({ style = "night" })
vim.cmd.colorscheme("tokyonight-night")

require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return "%2l:%-2v" end

defer.later("ui", function()
    vim.pack.add({
        "https://github.com/folke/which-key.nvim",
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/folke/todo-comments.nvim",
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        "https://github.com/NMAC427/guess-indent.nvim",
        "https://github.com/sphamba/smear-cursor.nvim",
    }, { confirm = false })

    require("which-key").setup({
        delay = 0,
        icons = { mappings = vim.g.have_nerd_font },
        spec = {
            { "<leader>c", group = "Copy" },
            { "<leader>g", group = "Git", mode = { "n", "v" } },
            { "<leader>s", group = "Search", mode = { "n", "v" } },
            { "<leader>t", group = "Toggle" },
            { "gr", group = "LSP", mode = { "n" } },
        },
    })

    require("todo-comments").setup({ signs = false })
    require("ibl").setup()
    require("guess-indent").setup({})
    require("smear_cursor").setup({
        stiffness = 0.8,
        trailing_stiffness = 0.6,
        stiffness_insert_mode = 0.7,
        trailing_stiffness_insert_mode = 0.7,
        damping = 0.95,
        damping_insert_mode = 0.95,
        distance_stop_animating = 0.5,
    })
end)
