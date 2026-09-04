local augroup = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Start treesitter highlighting",
    group = augroup("treesitter-start", { clear = true }),
    callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

vim.g.markdown_recommended_style = 0

vim.treesitter.language.register("json", "jsonc")

vim.filetype.add({
    extension = {
        env = "dotenv",
    },
    filename = {
        [".env"] = "dotenv",
        ["env"] = "dotenv",
    },
    pattern = {
        ["[jt]sconfig.*.json"] = "jsonc",
        ["%.env%.[%w_.-]+"] = "dotenv",
    },
})
