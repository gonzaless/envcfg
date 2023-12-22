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
    -- Bufferline
    ---------------------------------------------------------------------------
    {
        'akinsho/bufferline.nvim',
        version = "v3.*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                -----------------------------------------------------------
                -- Layout
                -----------------------------------------------------------
                --always_show_bufferline = true | false,
                --mode = "buffers", -- set to "tabs" to only show tabpages instead
                --numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = 'פּ File Explorer',
                        text_align = 'left',
                        separator = ' ',
                    }
                },


                -----------------------------------------------------------
                -- Tabs
                -----------------------------------------------------------
                color_icons = true, -- whether or not to add the filetype icon highlights
                --show_buffer_icons = true | false, -- disable filetype icons for buffers
                --show_buffer_close_icons = true | false,
                --show_buffer_default_icon = true | false, -- whether or not an unrecognised filetype should show a default icon
                --show_close_icon = true | false,
                show_tab_indicators = true,
                --show_duplicate_prefix = true | false, -- whether to show duplicate buffer prefix

                -- can also be a table containing 2 custom separators
                -- [focused and unfocused]. eg: { '|', '|' }
                --separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
                --enforce_regular_tabs = false | true,
                --hover = {
                    --enabled = true,
                    --delay = 200,
                    --reveal = {'close'}
                --},


                indicator = {
                    icon = '▎', -- this should be omitted if indicator style is not 'icon'
                    style = 'icon',
                    --style = 'icon' | 'underline' | 'none',
                },
                --buffer_close_icon = '',
                --modified_icon = '●',
                --close_icon = '',
                --left_truncMarker = '',
                --right_truncMarker = '',

                --- name_formatter can be used to change the buffer's label in the bufferline.
                --- Please note some names can/will break the
                --- bufferline so use this at your discretion knowing that it has
                --- some limitations that will *NOT* be fixed.
                --name_formatter = function(buf)  -- buf contains:
                       --name                | str        | the basename of the active file
                       --path                | str        | the full path of the active file
                       --bufnr (buffer only) | int        | the number of the active buffer
                       --buffers (tabs only) | table(int) | the numbers of the buffers in the tab
                       --tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
                --end,

                --max_name_length = 18,
                --max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
                --truncate_names = true, -- whether or not tab names should be truncated
                --tab_size = 18,

                -----------------------------------------------------------
                -- Tabs Extra
                -----------------------------------------------------------
                diagnostics = 'nvim_lsp',
                --diagnostics_update_in_insert = false,

                -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
                --diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    --return "("..count..")"
                --end,

                -----------------------------------------------------------
                -- Sort
                -----------------------------------------------------------
                --persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                --sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
                    --add custom logic
                    --return buffer_a.modified > buffer_b.modified
                --end,


                -----------------------------------------------------------
                -- Filter
                -----------------------------------------------------------
                --[[
                custom_filter = function(buf_number, buf_numbers)
                    -- NOTE: this will be called a lot so don't do any heavy processing here

                    -- filter out filetypes you don't want to see
                    if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                        return true
                    end
                    -- filter out by buffer name
                    if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                        return true
                    end
                    -- filter out based on arbitrary rules
                    -- e.g. filter out vim wiki buffer from tabline in your work repo
                    if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                        return true
                    end
                    -- filter out by it's index number in list (don't show first buffer)
                    if buf_numbers[1] ~= buf_number then
                        return true
                    end
                end,
                --]]

                -----------------------------------------------------------
                -- Mouse
                -----------------------------------------------------------
                --close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
                --leftMouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
                --middleMouse_command = nil,          -- can be a string | function, see "Mouse actions"
                --rightMouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
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
    },


    ---------------------------------------------------------------------------
    -- Dashboard
    ---------------------------------------------------------------------------
    {
        'glepnir/dashboard-nvim',
        config = function ()
            local db = require('dashboard')
            local leader = vim.g.mapleader
            local nvim_ver = vim.version()
            local nvim_ver_str = string.format('v%d.%d.%d', nvim_ver.major, nvim_ver.minor, nvim_ver.patch)

            db.preview_file_height = 11
            db.preview_file_width = 70

            db.default_banner = {
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
            }

            db.custom_center = {
                {
                    icon = '  ',
                    desc = 'Recent sessions                         ',
                    shortcut = leader .. 'sl',
                    action ='SessionLoad'
                },
                {
                    icon = '  ',
                    desc = 'Find recent files                       ',
                    action = 'Telescope oldfiles',
                    shortcut = leader .. 'fr'
                },
                {
                    icon = '  ',
                    desc = 'Find files                              ',
                    action = 'Telescope find_files find_command=rg,--hidden,--files',
                    shortcut = leader .. 'ff'
                },
                {
                    icon = '  ',
                    desc = 'Find buffers                            ',
                    action =  'Telescope file_browser',
                    shortcut = leader .. 'fb'
                },
                {
                    icon = '  ',
                    desc = 'Live grep                               ',
                    action = 'Telescope live_grep',
                    shortcut = leader .. 'fg'
                },
            }

            db.custom_footer = { '', os.date("%a %b %d, %Y %X") }
        end,
    },
}

