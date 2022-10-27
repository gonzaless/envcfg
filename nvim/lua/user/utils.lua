local M = {}


M.scan_dir = function (directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    if pfile ~= nil then
        for filename in pfile:lines() do
            if (filename ~= '.') and (filename ~= '..') then
                i = i + 1
                t[i] = filename
            end
        end
        pfile:close()
    end
    return t
end


M.script_path = function ()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end


M.with_opt_lib = function (lib_name, callback)
    vim.notify(string.format('DEBUG: with_opt_lib is called for %s', lib_name), vim.log.levels.WARN)
    local lib_found, lib = pcall(require, lib_name)
    if not lib_found or lib == nil then
        vim.notify(string.format('Library %s not found', lib_name), vim.log.levels.ERROR)
        return
    end
    vim.notify(string.format('DEBUG: with_opt_lib is calling callback for %s', lib_name), vim.log.levels.WARN)
    callback(lib)
end


local make_plugin_arg_to_action = {
    ['function'] = function (plugin, config)
        config(plugin)
    end,

    ['table'] = function (plugin, config)
        plugin.setup(config)
    end,
}

M.make_plugin_config = function (plugin_name, arg)
    vim.notify(string.format('DEBUG: MPC is called for %s : action type %s', plugin_name, type(arg)), vim.log.levels.WARN)
    vim.pretty_print(arg)
    vim.pretty_print(type(arg))
    local action = make_plugin_arg_to_action[type(arg)]
    vim.pretty_print(action)
    if action == nil then
        vim.notify(string.format('Failed to make pluging config for %s : unknown action type %s', plugin_name, type(arg)), vim.log.levels.ERROR)
        return
    end

    vim.notify(string.format('DEBUG: MPC is returning trampoline for %s : action type %s', plugin_name, type(arg)), vim.log.levels.WARN)
    local closure_pname = 'HEHEHE'
    local arg_type = 123
    return function ()
        vim.notify(string.format('DEBUG: MPC trampoline is called for %s : action type %d', closure_pname, arg_type), vim.log.levels.WARN)
        vim.notify(string.format('DEBUG: MPC trampoline is called for %s : action type %s', plugin_name, type(arg)), vim.log.levels.WARN)
        M.with_opt_lib(plugin_name, function (lib)
            vim.notify(string.format('DEBUG: MPC with_opt_lib is called for %s : action type %s', plugin_name, type(arg)), vim.log.levels.WARN)
            action(lib, arg)
        end)
        vim.notify(string.format('DEBUG: MPC trampoline is DONE for %s : action type %s', plugin_name, type(arg)), vim.log.levels.WARN)
    end
end


return M

