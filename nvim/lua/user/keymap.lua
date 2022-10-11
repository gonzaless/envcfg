-- Leader Key
local leader = ';'
vim.g.mapleader = leader
vim.g.maplocalleader = leader

-- Keymap
local keymap = vim.api.nvim_set_keymap
local noremap_silent = { noremap = true, silent = true }

-- Navigation
keymap('n', '<leader>e', ':Lex 24<CR>', noremap_silent)


-- Panels
keymap('n', '<C-Up>', ':resize -2<CR>', noremap_silent)
keymap('n', '<C-Down>', ':resize +2<CR>', noremap_silent)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', noremap_silent)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', noremap_silent)

keymap('n', '<C-h>', '<C-w>h', noremap_silent)
keymap('n', '<C-j>', '<C-w>j', noremap_silent)
keymap('n', '<C-k>', '<C-w>k', noremap_silent)
keymap('n', '<C-l>', '<C-w>l', noremap_silent)


-- Text Editing
keymap('v', '>', '>gv', noremap_silent)
keymap('v', '<', '<gv', noremap_silent)

keymap('v', '<A-j>', ':m .+1<CR>==', noremap_silent)          -- ?? Move selected text one line up
keymap('v', '<A-k>', ':m .-2<CR>==', noremap_silent)          -- ?? Move selected text one line down
keymap('x', 'J', ":move '>+1<CR>gv-gv", noremap_silent)
keymap('x', 'K', ":move '<-2<CR>gv-gv", noremap_silent)
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv", noremap_silent)   -- ??
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv", noremap_silent)   -- ??

keymap('v', 'p', '_dP', noremap_silent)                       -- keep original clipboard content when pasting over selection


-- Advanced Text Editing
keymap('n', '<C-/>', [[:call nerdcommenter#Comment('n', 'toggle')<CR>]], noremap_silent)

