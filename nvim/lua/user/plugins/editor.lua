local M = {}


M.setup = function (use)
    ---------------------------------------------------------------------------
    -- Text Editing
    ---------------------------------------------------------------------------
    use 'preservim/nerdcommenter'


    ---------------------------------------------------------------------------
    -- Text Rendering
    ---------------------------------------------------------------------------
    use 'lukas-reineke/indent-blankline.nvim'


    ---------------------------------------------------------------------------
    -- Syntax Highlighting
    ---------------------------------------------------------------------------
--[[
    use {'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update {
                with_sync = true
            }

            require'nvim-treesitter.configs'.setup {
                ensure_installed = { 'c', 'cmake', 'cpp', 'javascript', 'json', 'lua', 'python', 'rust' },
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
        end
    }
--]]
end


return M
