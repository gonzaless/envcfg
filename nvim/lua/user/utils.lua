return {
    scandir = function (directory)
        local i, t, popen = 0, {}, io.popen
        local pfile = popen('ls -a "'..directory..'"')
        for filename in pfile:lines() do
            if (filename ~= '.') and (filename ~= '..') then
                i = i + 1
                t[i] = filename
            end
        end
        pfile:close()
        return t
    end,

    script_path = function ()
       local str = debug.getinfo(2, "S").source:sub(2)
       return str:match("(.*/)")
    end,
}

