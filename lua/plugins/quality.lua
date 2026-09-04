local defer = require("defer")

local load_conform = defer.once("conform", function()
    vim.pack.add({
        "https://github.com/stevearc/conform.nvim",
    }, { confirm = false })

    require("conform").setup({
        notify_on_error = false,
        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            css = { "prettier" },
            scss = { "prettier" },
            json = { "prettier" },
            python = { "ruff_organize_imports", "ruff_format" },
            javascript = { "biome", "biome-organize-imports" },
            javascriptreact = { "biome", "biome-organize-imports" },
            typescript = { "biome", "biome-organize-imports" },
            typescriptreact = { "biome", "biome-organize-imports" },
        },
    })
end)

defer.on_event("conform", { "BufReadPre", "BufNewFile" }, load_conform)

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    load_conform()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

vim.api.nvim_create_user_command("ConformInfo", function()
    pcall(vim.api.nvim_del_user_command, "ConformInfo")
    load_conform()
    vim.cmd("ConformInfo")
end, { desc = "Load conform.nvim, then run :ConformInfo" })

defer.on_event("nvim-lint", { "BufReadPre", "BufNewFile" }, function()
    vim.pack.add({
        "https://github.com/mfussenegger/nvim-lint",
    }, { confirm = false })

    local lint = require("lint")

    lint.linters_by_ft = {
        go = { "golangcilint" },
        markdown = { "markdownlint" },
    }

    lint.linters.golangcilint.args = {
        "run",
        "--output.json.path=stdout",
        "--show-stats=false",
        "--issues-exit-code=0",
    }
    lint.linters.golangcilint.ignore_exitcode = true

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("Lint", { clear = true }),
        callback = function() lint.try_lint() end,
    })

    lint.try_lint()
end)
