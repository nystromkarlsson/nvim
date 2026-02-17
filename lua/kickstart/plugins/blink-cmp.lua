return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "2.*",
            build = (function()
                if
                    vim.fn.has("win32") == 1
                    or vim.fn.executable("make") == 0
                then
                    return
                end
                return "make install_jsregexp"
            end)(),
            opts = {},
        },
        "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            documentation = {
                auto_show = false,
                auto_show_delay_ms = 500,
            },
        },
        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "lazydev",
                "buffer",
            },
            providers = {
                lazydev = {
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                buffer = {
                    score_offset = -100,
                    enabled = function()
                        local enabled_filetypes = {
                            "markdown",
                            "text",
                        }
                        local filetype = vim.bo.filetype
                        return vim.tbl_contains(enabled_filetypes, filetype)
                    end,
                },
            },
        },
        snippets = { preset = "luasnip" },
        fuzzy = { implementation = "lua" },
        signature = { enabled = true },
    },
    event = "VimEnter",
}
