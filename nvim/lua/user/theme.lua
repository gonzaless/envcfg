-------------------------------------------------------------------------------
-- Preferred Colorschemes
-------------------------------------------------------------------------------
local preferred_colorschemes = {
    'gruvbox-material',
    'gruvbox',
    'everforest',
    'sonokai',
    'habamax',
    'desert'
}

for i, colorscheme in ipairs(preferred_colorschemes) do
    if pcall(vim.cmd.colorscheme, colorscheme) then
        break
    end
    vim.notify(string.format('Preferred colorscheme %d/%d "%s" is not found', i, #preferred_colorschemes, colorscheme), vim.log.levels.WARN)
end


