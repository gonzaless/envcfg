local M = {}
M.directory_separator = '/'


--
--  Strings
--

M.split_str = function (str, separator)
    if separator == nil then
        separator = '%s'
    end

    local result = {}
    for substr in str:gmatch('([^' .. separator .. ']+)') do
        table.insert(result, substr)
    end
    return result
end

M.split_path = function (path)
    return M.split_str(path, M.directory_separator)
end

M.join_path = function (...)
    local args = {...}
    local path_segments = {}
    local path_is_absolute = #args > 0 and args[1]:sub(1, 1) == M.directory_separator

    if path_is_absolute then
        path_segments[1] = ''
    end

    for _, arg in ipairs(args) do
        local arg_segments = M.split_path(arg)
        vim.list_extend(path_segments, arg_segments)
    end

    if path_is_absolute and #path_segments == 1 then
        path_segments[1] = M.directory_separator
    end

    return table.concat(path_segments, M.directory_separator)
end


--
--  File system
--

M.current_script_dir = function ()
    local calling_script_path = debug.getinfo(2, "S").source:sub(2)
    return calling_script_path:match("(.*/)")
end

M.scan_dir = function (directory)
    local dir_entries = {}

    local pfile = io.popen('ls -a "' .. directory .. '"')
    if pfile ~= nil then
        for filename in pfile:lines() do
            if (filename ~= '.') and (filename ~= '..') then
                table.insert(dir_entries, filename)
            end
        end
        pfile:close()
    end

    return dir_entries
end

return M

