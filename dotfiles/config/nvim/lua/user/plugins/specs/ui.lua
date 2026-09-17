return {
    ---------------------------------------------------------------------------
    -- Icons
    ---------------------------------------------------------------------------
    {
        'nvim-tree/nvim-web-devicons',
        opts = {
            -- globally enable different highlight colors per icon (default to true)
            -- if set to false all icons will have the default icon's color
            color_icons = true,

            -- globally enable default icons (default to false)
            -- will get overriden by `get_icons` option
            default = true,

            -- Can specify color or cterm_color instead of specifying both of them
            -- DevIcon will be appended to `name`
            --override = {
                --zsh = {
                    --icon = "",
                    --color = "#428850",
                    --cterm_color = "65",
                    --name = "Zsh",
                --}
            --},
        },
    },


    ---------------------------------------------------------------------------
    -- Buffers
    ---------------------------------------------------------------------------
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            sidebar_filetypes = {
                NvimTree = true,
            },
        },
    },


    ---------------------------------------------------------------------------
    -- Status
    ---------------------------------------------------------------------------
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divideMiddle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },

            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'},
            },

            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {},
            },

            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        },
    },


    ---------------------------------------------------------------------------
    -- Explorer
    ---------------------------------------------------------------------------
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons', },
        opts = {
            hijack_cursor = false,
            sort_by = "name",

            filters = {
                dotfiles = true,
            },

            renderer = {
                group_empty = true,
            },

            view = {
                adaptive_size = true,
            },

            on_attach= function (bufnr)
                local api = require('nvim-tree.api')
                api.config.mappings.default_on_attach(bufnr)

                -- key bindings should be defined here
                --local opts = function(desc)
                    --return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                --end
                --vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
                --vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
            end,
        },
    },


    ---------------------------------------------------------------------------
    -- Shortcut Hint
    ---------------------------------------------------------------------------
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- leave it empty to use the default settings
        },
    },
}

