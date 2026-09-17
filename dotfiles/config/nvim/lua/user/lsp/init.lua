local cmp_nvim_lsp_found, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_found then
    print('cmp_nvim_lsp module not found')
    cmp_nvim_lsp = nil
end

local utils = require('user.utils')


-------------------------------------------------------------------------------
-- Configuration
-------------------------------------------------------------------------------
local server_cfg_dir = 'servers'

local popup_border = 'none'  -- Options: none single double rounded solid shadow

local diagnostic_cfg = {
    float = {
        border = popup_border,
        --focusable = false,
        --header = '',
        --prefix = '',
        --style = 'minimal',
    },
    signs = {
        active = true,
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
        },
    },
    underline = true,
    virtual_text = true,
}


-------------------------------------------------------------------------------
-- Utils
-------------------------------------------------------------------------------
local function configure_ui()
    vim.diagnostic.config(diagnostic_cfg)

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = popup_border })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = popup_border, })
end


local function on_attach(client, bufnr)
    -- This function is a customization point, it is invoked by nvim's built-in client
    -- when attaching a buffer to a language server
end

local default_server_cfg = {
    capabilities = cmp_nvim_lsp ~= nil and cmp_nvim_lsp.default_capabilities() or {},
    on_attach = on_attach,
}

local function setup_server(server_name)
    local server_cfg_module = 'user.lsp.' .. server_cfg_dir .. '.' .. server_name
    local server_cfg_loaded, server_cfg = pcall(require, server_cfg_module)
    server_cfg = server_cfg_loaded and type(server_cfg) == 'table' and server_cfg or {}

    if server_cfg.on_attach then
        server_cfg.on_attach = nil  -- Override with default
    end

    local merged_server_cfg = vim.tbl_deep_extend('force', default_server_cfg, server_cfg)
    vim.lsp.config(server_name, merged_server_cfg)
end


local function setup_all_servers()
    local server_cfg_path = utils.join_path(utils.current_script_dir(), server_cfg_dir)
    local server_cfgs = utils.scan_dir(server_cfg_path)

    for _, server_cfg in ipairs(server_cfgs) do
        local server_name = server_cfg:match("(.+)%..+$")
        setup_server(server_name)
    end
end


-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
setup_all_servers()
configure_ui()

