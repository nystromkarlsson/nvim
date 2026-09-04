local defer = require("defer")

local load_dap = defer.once("nvim-dap", function()
    vim.pack.add({
        "https://github.com/mason-org/mason.nvim",
        "https://github.com/nvim-neotest/nvim-nio",
        "https://github.com/mfussenegger/nvim-dap",
        "https://github.com/rcarriga/nvim-dap-ui",
        "https://github.com/jay-babu/mason-nvim-dap.nvim",
        "https://github.com/leoluz/nvim-dap-go",
    }, { confirm = false })

    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = { "delve" },
    })

    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        ---@diagnostic disable-next-line: missing-fields
        controls = {
            icons = {
                pause = "⏸",
                play = "▶",
                step_into = "⏎",
                step_over = "⏭",
                step_out = "⏮",
                step_back = "b",
                run_last = "▶▶",
                terminate = "⏹",
                disconnect = "⏏",
            },
        },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require("dap-go").setup({ delve = { detached = vim.fn.has("win32") == 0 } })
end)

local function map(lhs, f, desc)
    vim.keymap.set("n", lhs, function()
        load_dap()
        f()
    end, { desc = desc })
end

map("<F5>", function() require("dap").continue() end, "Debug: Start / Continue")
map("<F1>", function() require("dap").step_into() end, "Debug: Step into")
map("<F2>", function() require("dap").step_over() end, "Debug: Step over")
map("<F3>", function() require("dap").step_out() end, "Debug: Step out")
map("<F7>", function() require("dapui").toggle() end, "Debug: See last session result")
map("<leader>b", function() require("dap").toggle_breakpoint() end, "Debug: Toggle breakpoint")

map("<leader>B", function()
    local dap = require("dap")

    ---@return dap.SourceBreakpoint
    local function find_bp()
        local buf_bps = require("dap.breakpoints").get(vim.fn.bufnr())[vim.fn.bufnr()]
        ---@type dap.SourceBreakpoint
        for _, candidate in ipairs(buf_bps or {}) do
            if candidate.line and candidate.line == vim.fn.line(".") then return candidate end
        end

        return {
            condition = "",
            logMessage = "",
            hitCondition = "",
            line = vim.fn.line("."),
        }
    end

    ---@param bp dap.SourceBreakpoint
    local function customize_bp(bp)
        local props = {
            ["Condition"] = {
                value = bp.condition,
                setter = function(v) bp.condition = v end,
            },
            ["Hit condition"] = {
                value = bp.hitCondition,
                setter = function(v) bp.hitCondition = v end,
            },
            ["Log message"] = {
                value = bp.logMessage,
                setter = function(v) bp.logMessage = v end,
            },
        }
        local menu_options = {}
        for k, _ in pairs(props) do
            table.insert(menu_options, k)
        end
        vim.ui.select(menu_options, {
            prompt = "Edit breakpoint",
            format_item = function(item) return ("%s: %s"):format(item, props[item].value) end,
        }, function(choice)
            if choice == nil then return end
            props[choice].setter(vim.fn.input({
                prompt = ("[%s] "):format(choice),
                default = props[choice].value,
            }))

            dap.set_breakpoint(bp.condition, bp.hitCondition, bp.logMessage)
        end)
    end

    customize_bp(find_bp())
end, "Debug: Edit breakpoint")
