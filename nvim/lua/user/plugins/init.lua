local utils = require('user.utils')


-------------------------------------------------------------------------------
-- Bootstrap plugin manager
-------------------------------------------------------------------------------
local bootstrap_plugin_manager = function()
    local source_url = 'https://github.com/folke/lazy.nvim.git'
    local install_path = utils.join_path(vim.fn.stdpath('data'), 'lazy/lazy.nvim')

    if not vim.loop.fs_stat(install_path) then
        vim.notify('Pluging manager not found at "' .. install_path .. '", bootstrapping from ' .. source_url .. ' ...', vim.log.levels.WARN)
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            source_url,
            '--branch=stable',
            install_path,
        })
    end
    vim.opt.rtp:prepend(install_path)

    local _, plugin_manager = pcall(require, 'lazy')
    return plugin_manager
end

local lazy = bootstrap_plugin_manager()
if lazy == nil then
    vim.notify('Failed to bootsrap pluging manager, all plugins are anavailable', vim.log.levels.ERROR)
    return
 end


-------------------------------------------------------------------------------
-- Setup plugins
-------------------------------------------------------------------------------
lazy.setup('user.plugins.specs')

