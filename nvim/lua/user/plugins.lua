vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Status line
    use {'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }

    -- Color schemes
    use 'morhetz/gruvbox'
    use 'sainnhe/gruvbox-material'
    use { "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" }
	use "lunarvim/darkplus.nvim"

    -- Highlighting
    use { 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate' }

    -- Text editing
    use 'lukas-reineke/indent-blankline.nvim'
    use 'preservim/nerdcommenter'

  -- Misc
    use {'glepnir/dashboard-nvim', config = function()
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
            '',
        }
        db.preview_file_height = 11
        db.preview_file_width = 70
        local leader = vim.g.mapleader
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
        db.custom_footer = { '', '🎉 Hello footer' }
    end}

  use { "folke/which-key.nvim", config = function()
  require("which-key").setup {

  }
  end}
end)

