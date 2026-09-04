local defer = require("defer")

defer.later("nvim-treesitter", function()
    vim.pack.add({
        {
            src = "https://github.com/nvim-treesitter/nvim-treesitter",
            version = "main",
        },
    }, { confirm = false })

    require("nvim-treesitter").setup()

    require("nvim-treesitter").install({
        "bash",
        "c",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    })
end)
