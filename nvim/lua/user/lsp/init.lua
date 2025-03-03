local lspconfig_found, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_found then
    return
end

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

local popup_border = 'none'  -- none single double rounded solid shadow

local diagnostic_cfg = {
    float = {
        border = popup_border,
        --focusable = false,
        --header = '',
        --prefix = '',
        --style = 'minimal',
    },
    signs = true,
    virtual_text = true,
}

local sign_overrides = {
    { name = "DiagnosticSignError", sign = { text = "", texthl = 'DiagnosticError', --[[culhl = '', linehl = '', numhl = ''--]] } },
    { name = "DiagnosticSignWarn" , sign = { text = "", texthl = 'DiagnosticWarn' } },
    { name = "DiagnosticSignHint" , sign = { text = "", texthl = 'DiagnosticHint' } },
    { name = "DiagnosticSignInfo" , sign = { text = "", texthl = 'DiagnosticInfo' } },
}


-------------------------------------------------------------------------------
-- Utils
-------------------------------------------------------------------------------
local function configure_ui()
    for _, override in ipairs(sign_overrides) do
        vim.fn.sign_define(override.name, override.sign)
    end

    vim.diagnostic.config(diagnostic_cfg)

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = popup_border })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = popup_border, })
end


local function on_attach(client, bufnr)
    -- This function is a customization point, it is invoked by Nvim's built-in client
    -- when attaching a buffer to a language server
end

local default_server_cfg = {
    capabilities = cmp_nvim_lsp ~= nil and cmp_nvim_lsp.default_capabilities() or {},
    on_attach = on_attach,
}

local function setup_server(server_name)
    local server = lspconfig[server_name]

    -- FIXME: this check never fails even if a server is not installed
    if server == nil then
        print(string.format('Failed to configure LSP server "%s" - it\'s not installed', server_name))
        return
    end

    local setup = server['setup']
    if setup == nil then
        print(string.format('Failed to configure LSP server "%s" - setup function is not available', server_name))
        return
    end

    local server_cfg_module = 'user.lsp.' .. server_cfg_dir .. '.' .. server_name
    local server_cfg_loaded, server_cfg = pcall(require, server_cfg_module)
    if not server_cfg_loaded then
        print(string.format('Failed to configure LSP server "%s" - can\'t load server config', server_name))
        return
    end

    if type(server_cfg) ~= 'table' then
        print(string.format('Failed to configure LSP server "%s" - server config doesn\'t return a table', server_name))
        return
    end

    if server_cfg['on_attach'] ~= nil then
        print(string.format('Warning: LSP server "%s" config defines "on_attach", it will be overwritten', server_name))
        server_cfg.on_attach = nil
    end

    local merged_server_cfg = vim.tbl_deep_extend('force', default_server_cfg, server_cfg)
    setup(merged_server_cfg)
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

