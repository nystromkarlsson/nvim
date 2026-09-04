local defer = require("defer")

defer.on_event("gitsigns", { "BufReadPre", "BufNewFile" }, function()
    vim.pack.add({
        "https://github.com/lewis6991/gitsigns.nvim",
    }, { confirm = false })

    require("gitsigns").setup({
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, { desc = "Jump to next git change" })

            map("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, { desc = "Jump to previous git change" })

            local function range() return { vim.fn.line("."), vim.fn.line("v") } end

            map("v", "<leader>gr", function() gitsigns.reset_hunk(range()) end, {
                desc = "Reset hunk",
            })
            map("v", "<leader>gs", function() gitsigns.stage_hunk(range()) end, {
                desc = "Toggle stage hunk",
            })

            map("n", "<leader>gb", gitsigns.blame_line, { desc = "Blame line" })
            map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff against index" })
            map("n", "<leader>gD", function() gitsigns.diffthis("@") end, {
                desc = "Diff against last commit",
            })
            map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
            map("n", "<leader>gP", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
            map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
            map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
            map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Toggle stage hunk" })
            map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })

            map("n", "<leader>tb", gitsigns.toggle_current_line_blame, {
                desc = "Git blame line",
            })
        end,
    })
end)

local load_fugitive = defer.once(
    "fugitive",
    function() vim.pack.add({ "https://github.com/tpope/vim-fugitive" }, { confirm = false }) end
)

vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status" })

local fugitive_cmds = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Gblame" }

for _, cmd in ipairs(fugitive_cmds) do
    vim.api.nvim_create_user_command(cmd, function(o)
        for _, c in ipairs(fugitive_cmds) do
            pcall(vim.api.nvim_del_user_command, c)
        end
        load_fugitive()
        vim.cmd(("%s%s %s"):format(cmd, o.bang and "!" or "", o.args))
    end, { nargs = "*", bang = true, desc = "Load fugitive, then run :" .. cmd })
end
