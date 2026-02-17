return {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            local disable_filetypes = {
                c = true,
                cpp = true,
            }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            javascript = { "biome", "biome-organize-imports" },
            javascriptreact = { "biome", "biome-organize-imports" },
            typescript = { "biome", "biome-organize-imports" },
            typescriptreact = { "biome", "biome-organize-imports" },
        },
    },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
}
