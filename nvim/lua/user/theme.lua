local colorschemes = {
    'gruvbox',
    'everforest',
    'sonokai',
    'habamax',
    'desert'
}

for _,colorscheme in ipairs(colorschemes) do
    local colorscheme_set, _ = pcall(vim.cmd, string.format('colorscheme %s', colorscheme))
    if colorscheme_set then
        break
    else
        vim.notify(string.format('Colorscheme "%s" not found!', colorscheme))
    end
end


-- General
vim.opt.termguicolors = true                              -- Enable 24bit color if the terminal supports it
vim.opt.cursorline = true                                 -- Highlight current line (underline by default)


-- Whitespace Rendering
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"
--vim.api.nvim_set_hl(0, 'Whitespace', {ctermfg=8})

local indent_blankline_found, indent_blankline = pcall(require, 'indent_blankline')
if indent_blankline_found and indent_blankline ~= nil then
    indent_blankline.setup {
        show_end_of_line = true,
        space_char_blankline = ' ',
    }
end

