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


return M

