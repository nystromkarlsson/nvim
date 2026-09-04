vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("pack-build", { clear = true }),
    callback = function(ev)
        local spec, kind, path = ev.data.spec, ev.data.kind, ev.data.path
        if kind == "delete" then return end

        if spec.name == "nvim-treesitter" then
            if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSUpdate")
        elseif spec.name == "telescope-fzf-native.nvim" then
            vim.system({ "make" }, { cwd = path }):wait()
        elseif spec.name == "LuaSnip" then
            if vim.fn.executable("make") == 1 then
                vim.system({ "make", "install_jsregexp" }, { cwd = path }):wait()
            end
        end
    end,
})

local function plugin_names()
    return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get(nil, { info = false }))
end

local function complete(arg)
    return vim.tbl_filter(function(n) return n:find(arg, 1, true) == 1 end, plugin_names())
end

vim.api.nvim_create_user_command(
    "PackUpdate",
    function(o) vim.pack.update(#o.fargs > 0 and o.fargs or nil, { force = o.bang }) end,
    {
        nargs = "*",
        bang = true,
        complete = complete,
        desc = "Update plugins (! to skip confirmation)",
    }
)

vim.api.nvim_create_user_command(
    "PackStatus",
    function() vim.pack.update(nil, { offline = true }) end,
    { desc = "Show plugin status (no fetch)" }
)

vim.api.nvim_create_user_command("PackClean", function(o)
    if #o.fargs == 0 then
        vim.pack.update(nil, { offline = true })
        vim.notify(
            "Put the cursor on a plugin and use gra -> delete, or run :PackClean <name>.",
            vim.log.levels.INFO
        )
        return
    end
    vim.pack.del(o.fargs)
end, {
    nargs = "*",
    complete = complete,
    desc = "Delete plugins from disk",
})

vim.api.nvim_create_user_command(
    "PackRevert",
    function() vim.pack.update(nil, { target = "lockfile" }) end,
    { desc = "Reset plugins to the lockfile state" }
)
