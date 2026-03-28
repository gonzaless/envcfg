return {
    ---------------------------------------------------------------------------
    -- Text Editing
    ---------------------------------------------------------------------------
    {
        'preservim/nerdcommenter',
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        dependencies = { 'hrsh7th/nvim-cmp' },
        config = function()
            require('nvim-autopairs').setup {}

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },


    ---------------------------------------------------------------------------
    -- Text Rendering
    ---------------------------------------------------------------------------
    {
        'lukas-reineke/indent-blankline.nvim',
    },


    ---------------------------------------------------------------------------
    -- Syntax Highlighting
    ---------------------------------------------------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function()
            pcall(function()
                local configs = require('nvim-treesitter.configs')
                configs.setup {
                    auto_install = true,  -- Auto-install parsers on fresh VM

                    ensure_installed = {
                        'c',
                        'cmake',
                        'cpp',
                        'javascript',
                        'json',
                        'lua',
                        'python',
                    },

                    highlight = {
                        enable = true,
                    },

                    indent = {
                        enabled = true,
                    },
                }
            end)
        end,
    },
}

