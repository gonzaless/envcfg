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
            require('nvim-treesitter.configs').setup {
                auto_install = false,  -- Automatically install missing parsers when entering buffer

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
                    enable = true, -- `false` will disable the whole extension

                    -- Disable selected languages
                    --disable = { "c", "rust" },
                    -- Or use a function for more flexibility, e.g. to disable slow treesitter hgighlight for large files
                    --disable = function(lang, buf)
                        --local max_filesize = 100 * 1024 -- 100 KB
                        --local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        --if ok and stats and stats.size > max_filesize then
                            --return true
                        --end
                    --end,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },

                indent = {
                    enabled = true,
                },
            }
        end,
    },
}

