local completion = require("plugins.completion")
local defer = require("defer")
local telescope = require("plugins.telescope")

defer.on_event("lsp", { "BufReadPre", "BufNewFile" }, function()
    vim.pack.add({
        "https://github.com/mason-org/mason.nvim",
        "https://github.com/mason-org/mason-lspconfig.nvim",
        "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
        "https://github.com/j-hui/fidget.nvim",
        "https://github.com/neovim/nvim-lspconfig",
    }, { confirm = false })

    require("mason").setup()
    require("fidget").setup({})

    completion.setup()

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
            local map = function(keys, func, desc, mode)
                vim.keymap.set(mode or "n", keys, func, {
                    buffer = event.buf,
                    desc = desc,
                })
            end

            map(
                "<leader>td",
                function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
                "Diagnostics"
            )
            map("gO", telescope.builtin("lsp_document_symbols"), "LSP document symbols")
            map("gW", telescope.builtin("lsp_dynamic_workspace_symbols"), "LSP workspace symbols")
            map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
            map("grd", telescope.builtin("lsp_definitions"), "Goto definition")
            map("grD", vim.lsp.buf.declaration, "Goto declaration")
            map("gri", telescope.builtin("lsp_implementations"), "Goto implementation")
            map("grn", vim.lsp.buf.rename, "Rename")
            map("grr", telescope.builtin("lsp_references"), "Goto references")
            map("grt", telescope.builtin("lsp_type_definitions"), "Goto type definition")

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if
                client
                and client:supports_method(
                    vim.lsp.protocol.Methods.textDocument_documentHighlight,
                    event.buf
                )
            then
                local highlight_augroup =
                    vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })
                vim.api.nvim_create_autocmd("LspDetach", {
                    group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                    callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds({
                            group = "lsp-highlight",
                            buffer = event2.buf,
                        })
                    end,
                })
            end

            if
                client
                and client:supports_method(
                    vim.lsp.protocol.Methods.textDocument_inlayHint,
                    event.buf
                )
            then
                map(
                    "<leader>th",
                    function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
                        )
                    end,
                    "Inlay hints"
                )
            end
        end,
    })

    vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        signs = vim.g.have_nerd_font and {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
                [vim.diagnostic.severity.INFO] = "󰋽 ",
                [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
        } or {},
        virtual_text = { source = "if_many", spacing = 2 },
        virtual_lines = true,
    })

    ---@type table<string, vim.lsp.Config>
    local servers = {
        gopls = {},
        lua_ls = {
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    workspace = {
                        checkThirdParty = false,
                        library = { vim.env.VIMRUNTIME },
                    },
                },
            },
        },
        pyright = {
            settings = { pyright = { disableOrganizeImports = true } },
        },
        ruff = {},
    }

    for server, config in pairs(servers) do
        if not vim.tbl_isempty(config) then vim.lsp.config(server, config) end
    end

    require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_enable = { exclude = { "stylua" } },
    })

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
        "biome",
        "golangci-lint",
        "markdownlint",
        "prettier",
        "stylua",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
end)

defer.on_ft("typescript-tools", {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
}, function()
    vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/neovim/nvim-lspconfig",
        "https://github.com/pmizio/typescript-tools.nvim",
    }, { confirm = false })

    require("typescript-tools").setup({})
end)
