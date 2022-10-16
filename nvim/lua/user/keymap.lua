-- Leader Key
local leader = ';'
vim.g.mapleader = leader
vim.g.maplocalleader = leader

-- Keymap
local keymap = function(mode, lhs, rhs, opts)
    if opts == nil then
        opts = { noremap = true, silent = true }
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end


-- Navigation
keymap('n', '<leader>e', ':Lex 24<CR>')


-- Window Resize
keymap('n', '<C-Up>', ':resize -2<CR>')
keymap('n', '<C-Down>', ':resize +2<CR>')
keymap('n', '<C-Left>', ':vertical resize -2<CR>')
keymap('n', '<C-Right>', ':vertical resize +2<CR>')

-- Windows Navigation
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')


-- File Explorer
keymap('n', '<Leader>e', ':NvimTreeToggle<CR>')
--keymap('n', '<Leader>t', ':NvimTreeFocus<CR>')


-- Text Editing
keymap('v', '>', '>gv')
keymap('v', '<', '<gv')

keymap('v', '<A-j>', ':m .+1<CR>==')          -- ?? Move selected text one line up
keymap('v', '<A-k>', ':m .-2<CR>==')          -- ?? Move selected text one line down
keymap('x', 'J', ":move '>+1<CR>gv-gv")
keymap('x', 'K', ":move '<-2<CR>gv-gv")
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv")   -- ??
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv")   -- ??

keymap('v', 'p', '_dP')                       -- keep original clipboard content when pasting over selection


-- Advanced Text Editing
keymap('n', '<C-/>', [[:call nerdcommenter#Comment('n', 'toggle')<CR>]])


-- LSP
--keymap('n', '<space>e', vim.diagnostic.open_float)
--keymap('n', '[d', vim.diagnostic.goto_prev)
--keymap('n', ']d', vim.diagnostic.goto_next)
--keymap('n', '<space>q', vim.diagnostic.setloclist)

