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
    local function keymap(mode, lhs, rhs, opts)
        if opts == nil then
            opts = { noremap = true, silent = true }
        end
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Keymap
    keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    -- keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    -- keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    -- keymap('n', '<leader>f', '<cmd>lua vim.diagnostic.open_float()<CR>')
    --keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
    --keymap('n', 'gl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>')
    --keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
    --keymap('n', "<leader>q", '<cmd>lua vim.diagnostic.setloclist()<CR>')
    --vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]


    -- Enable completion triggered by <C-x><C-O>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end


local cmp_capabilities = cmp_nvim_lsp ~= nil and cmp_nvim_lsp.default_capabilities() or {}

local default_server_cfg = {
    on_attach = on_attach,
    capabilities = cmp_capabilities,
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
    local server_cfg_path = utils.script_path() .. '/' .. server_cfg_dir
    local server_cfgs = utils.scandir(server_cfg_path)

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

