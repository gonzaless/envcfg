return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function()
            local nvim_ver = vim.version()
            local nvim_ver_str = string.format('v%d.%d.%d', nvim_ver.major, nvim_ver.minor, nvim_ver.patch)
            return {
                theme = 'hyper',
                config = {
                    header = {
                        '',
                        '',
                        ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
                        ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
                        ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
                        ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
                        ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
                        ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
                        '',
                        nvim_ver_str,
                        '',
                    },
                    shortcut = {
                        { desc = ' Telescope', group = 'DashboardShortCut',  key = 't', action = 'Telescope' },
                        { desc = ' Plugins', group = 'DashboardShortCut',  key = 'p', action = 'Lazy' },
                    },
                },
            }
        end,
    },
}
