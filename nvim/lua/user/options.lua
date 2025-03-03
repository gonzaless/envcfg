-- Clipboard
vim.opt.clipboard = 'unnamedplus'                         -- Use system clipboard


-- Display
vim.opt.cursorline = true                                 -- Highlight current line (underline by default)
vim.opt.number = true                                     -- Line number
vim.opt.showmatch = true                                  -- Matching brackets handling
vim.opt.termguicolors = true                              -- Enable 24bit color if the terminal supports it
--vim.opt.title = true                                      -- Show file title
--vim.opt.wildmenu = true                                   -- Show advanced menu
vim.opt.wrap = false                                      -- display lines as one long line


-- Editing
vim.opt.expandtab = true                                  -- Convert tabs to spaces
vim.opt.shiftwidth = 4                                    -- Indentation length
vim.opt.tabstop = 4                                       -- Tab stop each 4 chars (max tab expansion length)


-- Keyboard
local leader_key = ';'
vim.g.mapleader = leader_key
vim.g.maplocalleader = leader_key


-- Mouse
vim.opt.mouse = 'a'                                       -- Enable mouse


-- Navigation
vim.opt.scrolloff = 8                                     -- Vertical scroll offset in lines
vim.opt.sidescrolloff = 8                                 -- Horizontal scroll offset in chars


-- Explorer (disable in favor of nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Search
vim.opt.hlsearch = true                                   -- Highlight search
vim.opt.ignorecase = true                                 -- Ignore case when searching


-- Spellchecking
vim.opt.spell = true
vim.opt.spelllang = "en_us"


-- Whitespace Rendering
vim.opt.list = true
vim.opt.listchars:append "space:·"
-- vim.opt.listchars:append "eol:↴"
--vim.api.nvim_set_hl(0, 'Whitespace', {ctermfg=8})

