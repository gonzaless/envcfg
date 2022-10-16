local utils = require('user.utils')
local lspconfig_found, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_found then
    return
end


-- Search for available configs
local servers_dir = utils.script_path() .. '/servers'
local servers = utils.scandir(servers_dir)

-- Apply each language server config
for _, server_file in ipairs(servers) do
    local server = server_file:match("(.+)%..+$")
    print(server_file, ' -> ', server)
    if lspconfig[server] ~= nil then
        print('DEBUG: detected server: ', server)
    end
end

