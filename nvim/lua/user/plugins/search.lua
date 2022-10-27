local M = {}


M.setup = function (use)
    use {'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function ()
            local telescope_found, telescope = pcall(require, "telescope")
            if not telescope_found then
              return
            end

            local actions = require "telescope.actions"
            --telescope.load_extension('media_files')

            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,

                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,

                            --["<C-c>"] = actions.close,

                            --["<CR>"] = actions.select_default,
                            --["<C-x>"] = actions.select_horizontal,
                            --["<C-v>"] = actions.select_vertical,
                            --["<C-t>"] = actions.select_tab,

                            --["<C-u>"] = actions.preview_scrolling_up,
                            --["<C-d>"] = actions.preview_scrolling_down,

                            --["<PageUp>"] = actions.results_scrolling_up,
                            --["<PageDown>"] = actions.results_scrolling_down,

                            --["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            --["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            --["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            --["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            --["<C-l>"] = actions.complete_tag,
                            --["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                        },

                        n = {
                            --["<esc>"] = actions.close,
                            --["<CR>"] = actions.select_default,
                            --["<C-x>"] = actions.select_horizontal,
                            --["<C-v>"] = actions.select_vertical,
                            --["<C-t>"] = actions.select_tab,

                            --["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            --["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            --["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            --["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            --["H"] = actions.move_to_top,
                            --["M"] = actions.move_to_middle,
                            --["L"] = actions.move_to_bottom,

                            --["<Down>"] = actions.move_selection_next,
                            --["<Up>"] = actions.move_selection_previous,
                            --["gg"] = actions.move_to_top,
                            --["G"] = actions.move_to_bottom,

                            --["<C-u>"] = actions.preview_scrolling_up,
                            --["<C-d>"] = actions.preview_scrolling_down,

                            --["<PageUp>"] = actions.results_scrolling_up,
                            --["<PageDown>"] = actions.results_scrolling_down,

                            --["?"] = actions.which_key,
                        },
                    },
                },
            }
        end
    }
end


return M
