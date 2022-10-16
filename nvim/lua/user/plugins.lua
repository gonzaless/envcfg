-- Bootstrap
local bootstrap_packer = function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrapped = bootstrap_packer()
local packer_found, packer = pcall(require, "packer")
if not packer_found then
    vim.notify('Packer not found. Bootstrap failed')
    return
end


-- Auto update on save
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])


-- Initialization
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}


-- Plugins
return packer.startup(function(use)
    use 'wbthomason/packer.nvim'


    ---------------------------------------------------------------------------
    -- Color schemes
    ---------------------------------------------------------------------------
    use 'morhetz/gruvbox'
    use 'sainnhe/gruvbox-material'
    use 'ajmwagar/vim-deus'
    use 'sainnhe/everforest'
    use 'sainnhe/sonokai'


    ---------------------------------------------------------------------------
    -- Icons
    ---------------------------------------------------------------------------
    --use 'ryanoasis/vim-devicons'
    use {'nvim-tree/nvim-web-devicons', config = function()
        -- Can specify color or cterm_color instead of specifying both of them
        -- DevIcon will be appended to `name`
        --override = {
            --zsh = {
                --icon = "",
                --color = "#428850",
                --cterm_color = "65",
                --name = "Zsh"
            --}
         --};

         -- globally enable different highlight colors per icon (default to true)
         -- if set to false all icons will have the default icon's color
         color_icons = true;

         -- globally enable default icons (default to false)
         -- will get overriden by `get_icons` option
         default = true;
    end}


    ---------------------------------------------------------------------------
    -- Text editing
    ---------------------------------------------------------------------------
    use 'preservim/nerdcommenter'


    ---------------------------------------------------------------------------
    -- Text rendering
    ---------------------------------------------------------------------------
    use 'lukas-reineke/indent-blankline.nvim'
    use {'nvim-treesitter/nvim-treesitter', run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
    end}


    ---------------------------------------------------------------------------
    -- Explorer
    ---------------------------------------------------------------------------
    use {'nvim-tree/nvim-tree.lua',
        --tag = 'nightly',
        requires = 'nvim-tree/nvim-web-devicons', -- optional, for file icons
        --wants = 'nvim-web-devicons',
        config = function() require('nvim-tree').setup {
            sort_by = "case_sensitive",
            view = {
                adaptive_size = true,
                mappings = {
                    list = {
                        { key = "u", action = "dir_up" },
                    },
                },
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        }
    end}


    ---------------------------------------------------------------------------
    -- Status line
    ---------------------------------------------------------------------------
    use {'nvim-lualine/lualine.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        wants = 'nvim-web-devicons',

        config = function() require('lualine').setup {
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
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
    end}


    ---------------------------------------------------------------------------
    -- Misc
    ---------------------------------------------------------------------------
    use {'glepnir/dashboard-nvim', config = function()
        local leader = vim.g.mapleader
        local nvim_ver = vim.version()
        local nvim_ver_str = string.format('v%d.%d.%d', nvim_ver.major, nvim_ver.minor, nvim_ver.patch)

        local db = require('dashboard')
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
        db.preview_file_height = 11
        db.preview_file_width = 70
        
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
                desc ='File browser                            ',
                action =  'Telescope file_browser',
                shortcut = leader .. 'fb'
            },
            {
                icon = '  ',
                desc = 'Find word                               ',
                action = 'Telescope live_grep',
                shortcut = leader .. 'fw'
            },
            {
                icon = '  ',
                desc = 'Load new theme                          ',
                action = 'Telescope colorscheme',
                shortcut = leader .. 'ht'
            },
        }
        db.custom_footer = { '', os.date("%a %b %d, %Y %X") }
    end}

    use { "folke/which-key.nvim", config = function()
        require("which-key").setup {

        }
    end}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrapped then
        packer.sync()
    end
end)

