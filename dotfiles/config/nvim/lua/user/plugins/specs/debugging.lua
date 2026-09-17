return {
    {
        'mfussenegger/nvim-dap',
        config = function ()
            local dap = require('dap')
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
            }
            dap.configurations.c = {
                {
                    name = 'Run executable (GDB)',
                    type = 'gdb',
                    request = 'launch',
                    -- This requires special handling of 'run_last', see
                    -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
                    program = function()
                        local path = vim.fn.input({
                            prompt = 'Path to executable: ',
                            default = vim.fn.getcwd() .. '/',
                            completion = 'file',
                        })

                        return (path and path ~= '') and path or dap.ABORT
                    end,
                },
                {
                    name = 'Run executable with arguments (GDB)',
                    type = 'gdb',
                    request = 'launch',
                    -- This requires special handling of 'run_last', see
                    -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
                    program = function()
                        local path = vim.fn.input({
                            prompt = 'Path to executable: ',
                            default = vim.fn.getcwd() .. '/',
                            completion = 'file',
                        })

                        return (path and path ~= '') and path or dap.ABORT
                    end,
                    args = function()
                        local args_str = vim.fn.input({
                            prompt = 'Arguments: ',
                        })
                        return vim.split(args_str, ' +')
                    end,
                },
                {
                    name = 'Attach to process (GDB)',
                    type = 'gdb',
                    request = 'attach',
                    processId = require('dap.utils').pick_process,
                },
            }

            --if vim.fn.executable('gdb') == 1 then
                -- TODO TODO TODO
                -- See why the module is not available
                --require('plugins.dap.c')
            --end

            vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {})
            vim.keymap.set('n', '<F2>', dap.restart, {})
            vim.keymap.set('n', '<F3>', dap.run_to_cursor, {})
            vim.keymap.set('n', '<F5>', dap.continue, {})
            vim.keymap.set('n', '<F6>', dap.step_over, {})
            vim.keymap.set('n', '<F7>', dap.step_into, {})
            vim.keymap.set('n', '<F8>', dap.step_back, {})
        end
    },
    {
        'nvim-neotest/nvim-nio',
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'},
        config = function ()
            local dapui = require('dapui')
            dapui.setup({})
            local dap = require('dap')
            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close
        end
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = {'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter'},
    },
}
