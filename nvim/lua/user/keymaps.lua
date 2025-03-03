-- Utils
local keymap = function(mode, lhs, rhs, opts)
    if opts == nil then
        opts = { noremap = true, silent = true }
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end


-- Buffers
keymap('n', '<leader>bc', '<Cmd>BufferClose<CR>')
keymap('n', '<leader>bm', '<Cmd>BufferPick<CR>')
keymap('n', '<leader>bp', '<Cmd>BufferPrevious<CR>')
keymap('n', '<leader>bn', '<Cmd>BufferNext<CR>')


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


-- Search
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
keymap('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>')


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
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
--keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
--keymap('n', '<leader>f', '<cmd>lua vim.diagnostic.open_float()<CR>')
--keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
--keymap('n', 'gl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>')
--keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
--keymap('n', "<leader>q", '<cmd>lua vim.diagnostic.setloclist()<CR>')
--vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

