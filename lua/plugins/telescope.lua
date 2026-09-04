local defer = require("defer")

local M = {}

M.load = defer.once("telescope", function()
    vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/nvim-telescope/telescope-ui-select.nvim",
        "https://github.com/nvim-telescope/telescope.nvim",
    }, { confirm = false })

    if vim.fn.executable("make") == 1 then
        vim.pack.add({
            "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
        }, { confirm = false })
    end

    if vim.g.have_nerd_font then
        vim.pack.add({
            "https://github.com/nvim-tree/nvim-web-devicons",
        }, { confirm = false })
    end

    require("telescope").setup({
        extensions = {
            ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
end)

function M.builtin(name, opts)
    return function()
        M.load()
        require("telescope.builtin")[name](opts)
    end
end

local function dropdown(name, opts)
    return function()
        M.load()
        require("telescope.builtin")[name](require("telescope.themes").get_dropdown(opts))
    end
end

local map = vim.keymap.set
local b = M.builtin

local buffer_fuzzy = dropdown("current_buffer_fuzzy_find", { winblend = 10, previewer = false })
local config_files = b("find_files", { cwd = vim.fn.stdpath("config") })
local open_files = b("live_grep", {
    grep_open_files = true,
    prompt_title = "Live grep in open files",
})

local function todo_comments()
    M.load()
    vim.cmd("TodoTelescope")
end

map("n", "<leader><leader>", b("buffers"), { desc = "Buffers" })
map("n", "<leader>/", buffer_fuzzy, { desc = "Fuzzy find in buffer" })

map("n", "<leader>s/", open_files, { desc = "Grep open files" })
map("n", "<leader>sd", b("diagnostics"), { desc = "Diagnostics" })
map("n", "<leader>sf", b("find_files"), { desc = "Find files" })
map("n", "<leader>sg", b("live_grep"), { desc = "Live grep" })
map("n", "<leader>sh", b("help_tags"), { desc = "Help tags" })
map("n", "<leader>sk", b("keymaps"), { desc = "Keymaps" })
map("n", "<leader>sn", config_files, { desc = "Neovim config files" })
map("n", "<leader>so", b("oldfiles"), { desc = "Old files" })
map("n", "<leader>sr", b("resume"), { desc = "Resume last picker" })
map("n", "<leader>ss", b("builtin"), { desc = "Telescope pickers" })
map("n", "<leader>st", todo_comments, { desc = "Todo comments" })
map({ "n", "v" }, "<leader>sw", b("grep_string"), { desc = "Word under cursor" })

vim.api.nvim_create_user_command("Telescope", function(o)
    pcall(vim.api.nvim_del_user_command, "Telescope")
    M.load()
    vim.cmd(("Telescope %s"):format(o.args))
end, { nargs = "*", desc = "Load Telescope, then run :Telescope" })

return M
