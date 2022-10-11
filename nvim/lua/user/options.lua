-- Clipboard
vim.opt.clipboard = 'unnamedplus'                         -- Use system clipboard


-- Editing
vim.opt.expandtab = true                                  -- Convert tabs to spaces
vim.opt.shiftwidth = 4                                    -- Indentation length
vim.opt.tabstop = 4                                       -- Tab stop each 4 chars (max tab expansion length)


-- Display
vim.opt.number = true                                     -- Line number
vim.opt.showmatch = true                                  -- Matching brackets handling
--vim.opt.title = true                                      -- Show file title
--vim.opt.wildmenu = true                                   -- Show advanced menu
vim.opt.wrap = false                                      -- display lines as one long line


-- Mouse
vim.opt.mouse = 'a'                                       -- Enable mouse


-- Navigation
vim.opt.scrolloff = 8                                     -- Vertical scroll offset in lines
vim.opt.sidescrolloff = 8                                 -- Horizontal scroll offset in chars


-- Search
vim.opt.hlsearch = true                                   -- Highlight search
vim.opt.ignorecase = true                                 -- Ignore case when searching


-- Spellchecking
vim.cmd("command Spell setlocal spell! spelllang=en_us")  -- Enable spell checking, vim.opt.assumed language
