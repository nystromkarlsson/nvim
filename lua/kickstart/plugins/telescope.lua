return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function() return vim.fn.executable("make") == 1 end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        {
            "nvim-tree/nvim-web-devicons",
            enabled = vim.g.have_nerd_font,
        },
    },
    config = function()
        require("telescope").setup({
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown() },
            },
        })

        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        local builtin = require("telescope.builtin")
        vim.keymap.set(
            "n",
            "<leader>sh",
            builtin.help_tags,
            { desc = "Search help" }
        )
        vim.keymap.set(
            "n",
            "<leader>sk",
            builtin.keymaps,
            { desc = "Search keymaps" }
        )
        vim.keymap.set(
            "n",
            "<leader>sf",
            builtin.find_files,
            { desc = "Search files" }
        )
        vim.keymap.set(
            "n",
            "<leader>ss",
            builtin.builtin,
            { desc = "Search select telescope" }
        )
        vim.keymap.set(
            {
                "n",
                "v",
            },
            "<leader>sw",
            builtin.grep_string,
            {
                desc = "Search current word",
            }
        )
        vim.keymap.set(
            "n",
            "<leader>sg",
            builtin.live_grep,
            { desc = "Search by grep" }
        )
        vim.keymap.set(
            "n",
            "<leader>sd",
            builtin.diagnostics,
            { desc = "Search diagnostics" }
        )
        vim.keymap.set(
            "n",
            "<leader>sr",
            builtin.resume,
            { desc = "Search resume" }
        )
        vim.keymap.set(
            "n",
            "<leader>s.",
            builtin.oldfiles,
            { desc = 'Search recent files ("." for repeat)' }
        )
        vim.keymap.set(
            "n",
            "<leader><leader>",
            builtin.buffers,
            { desc = "Find existing buffers" }
        )

        vim.keymap.set(
            "n",
            "<leader>/",
            function()
                builtin.current_buffer_fuzzy_find(
                    require("telescope.themes").get_dropdown({
                        winblend = 10,
                        previewer = false,
                    })
                )
            end,
            { desc = "Fuzzily search in current buffer" }
        )

        vim.keymap.set(
            "n",
            "<leader>s/",
            function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live grep in open files",
                })
            end,
            { desc = "Search in open files" }
        )

        vim.keymap.set(
            "n",
            "<leader>sn",
            function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
            { desc = "Search Neovim files" }
        )
    end,
    event = "VimEnter",
}

-- vim: ts=2 sts=2 sw=2 et
