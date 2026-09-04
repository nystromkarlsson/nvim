local M = {}

function M.setup()
    vim.pack.add({
        "https://github.com/folke/lazydev.nvim",
        { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2") },
        "https://github.com/zbirenbaum/copilot.lua",
        "https://github.com/giuxtaposition/blink-cmp-copilot",
        { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
    }, { confirm = false })

    require("luasnip").setup()

    require("lazydev").setup({
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    })

    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })

    require("blink.cmp").setup({
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },
        sources = {
            default = { "lsp", "path", "snippets", "lazydev", "copilot", "buffer" },
            providers = {
                lazydev = {
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 100,
                    async = true,
                },
                buffer = {
                    score_offset = -100,
                    enabled = function()
                        return vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype)
                    end,
                },
            },
        },
        snippets = { preset = "luasnip" },
        signature = { enabled = true },
    })
end

return M
