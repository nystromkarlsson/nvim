local defer = require("defer")

defer.later("leap", function()
    vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" }, { confirm = false })

    local leap = require("leap")

    leap.opts.preview = function(ch0, ch1, ch2)
        return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
    end

    leap.opts.equivalence_classes = {
        " \t\r\n",
        "([{",
        ")]}",
        "'\"`",
    }

    require("leap.user").set_repeat_keys("<enter>", "<backspace>")

    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
    vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
end)

defer.on_event("autopairs", "InsertEnter", function()
    vim.pack.add({ "https://github.com/windwp/nvim-autopairs" }, { confirm = false })
    require("nvim-autopairs").setup()
end)

defer.on_ft("nvim-ts-autotag", {
    "html",
    "javascript",
    "javascriptreact",
    "markdown",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
    "xml",
}, function()
    vim.pack.add({ "https://github.com/windwp/nvim-ts-autotag" }, { confirm = false })
    require("nvim-ts-autotag").setup()
end)

local load_oil = defer.once("oil", function()
    vim.pack.add({
        "https://github.com/nvim-mini/mini.icons",
        "https://github.com/stevearc/oil.nvim",
    }, { confirm = false })

    require("mini.icons").setup()
    require("oil").setup({ view_options = { show_hidden = true } })
end)

vim.keymap.set("n", "<leader>o", function()
    load_oil()
    vim.cmd("Oil")
end, { desc = "Open Oil" })

vim.api.nvim_create_user_command("Oil", function(o)
    pcall(vim.api.nvim_del_user_command, "Oil")
    load_oil()
    vim.cmd(("Oil %s"):format(o.args))
end, { nargs = "*", desc = "Load oil.nvim, then run :Oil" })
