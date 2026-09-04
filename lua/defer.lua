local M = {}

local function guard(name, f)
    return function(...)
        local ok, err = pcall(f, ...)
        if not ok then
            local msg = ("plugin '%s' failed to load: %s"):format(name, err)
            vim.schedule(function() vim.notify(msg, vim.log.levels.ERROR) end)
        end
    end
end

function M.later(name, f) vim.schedule(guard(name, f)) end

function M.on_event(name, events, f)
    vim.api.nvim_create_autocmd(events, {
        once = true,
        group = vim.api.nvim_create_augroup("defer." .. name, { clear = true }),
        callback = guard(name, f),
    })
end

function M.on_ft(name, filetypes, f)
    local run = guard(name, f)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        once = true,
        group = vim.api.nvim_create_augroup("defer." .. name, { clear = true }),
        callback = function(ev)
            run()
            vim.api.nvim_exec_autocmds("FileType", {
                buffer = ev.buf,
                modeline = false,
            })
        end,
    })
end

function M.once(name, f)
    local done, run = false, guard(name, f)
    return function()
        if not done then
            done = true
            run()
        end
    end
end

return M
