vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
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
    -- Text editing
    ---------------------------------------------------------------------------
    use 'preservim/nerdcommenter'


    ---------------------------------------------------------------------------
    -- Text rendering
    ---------------------------------------------------------------------------
    use 'lukas-reineke/indent-blankline.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
    end}


    ---------------------------------------------------------------------------
    -- Status line
    ---------------------------------------------------------------------------
    use {'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }


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
end)

