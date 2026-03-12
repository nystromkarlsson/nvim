return {
    "wnkz/monoglow.nvim",
    enabled = false,
    lazy = false,
    opts = {},
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true
        vim.cmd.colorscheme("monoglow-z")
    end,
}
