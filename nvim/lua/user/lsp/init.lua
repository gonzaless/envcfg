local lspconfig_found, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_found then
    return
end

local utils = require('user.utils')


-------------------------------------------------------------------------------
-- Configuration
-------------------------------------------------------------------------------
local server_cfg_dir = 'servers'


-------------------------------------------------------------------------------
-- Utils
-------------------------------------------------------------------------------
local function on_attach(client, bufnr)
    print('DEBUG: one_attach called ...')
    local keymap = function(mode, lhs, rhs, opts)
        if opts == nil then
            opts = { noremap = true, silent = true }
        end
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Keymap
    keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
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


    print('DEBUG: one_attach done')
end


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

    server_cfg.on_attach = on_attach
    setup(server_cfg)
end


local function setup_all_servers()
    local server_cfg_path = utils.script_path() .. '/' .. server_cfg_dir
    local server_cfgs = utils.scandir(server_cfg_path)

    for _, server_cfg in ipairs(server_cfgs) do
        local server_name = server_cfg:match("(.+)%..+$")
        print(server_cfg, ' -> ', server_name)
        setup_server(server_name)
    end
end


-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
setup_all_servers()

