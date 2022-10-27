-------------------------------------------------------------------------------
-- Bootstrap
-------------------------------------------------------------------------------
local bootstrap_packer = function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrapped = bootstrap_packer()
local packer_found, packer = pcall(require, "packer")
if not packer_found then
    vim.notify('Packer not found. Bootstrap failed', vim.log.levels.ERROR)
    return
end


-------------------------------------------------------------------------------
-- Auto update on save
-------------------------------------------------------------------------------
local plugin_module_pattern = require('user.utils').script_path() .. '*.lua'

vim.api.nvim_create_autocmd(
    'BufWritePost',
    { 
        pattern = plugin_module_pattern,
        command = 'PackerSync', 
    }
)


-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}


-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
return packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    local setup_group = function (name)
        local group_found, group = pcall(require, name)
        if not group_found or group == nil then
            vim.notify(string.format("Can't find pluging group '%s'", name), vim.log.levels.ERROR)
            return
        end

        if group.setup == nil then
            vim.notify(string.format("Can't setup pluging group '%s': setup function is nil", name), vim.log.levels.ERROR)
            return
        end

        group.setup(use)
    end

    setup_group('user.plugins.colorschemes')
    setup_group('user.plugins.editor')
    setup_group('user.plugins.lsp')
    setup_group('user.plugins.cmp')
    setup_group('user.plugins.ui')
    setup_group('user.plugins.search')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrapped then
        packer.sync()
    end
end)

