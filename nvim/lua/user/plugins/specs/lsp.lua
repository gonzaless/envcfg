return {
    ---------------------------------------------------------------------------
    -- LSP
    ---------------------------------------------------------------------------
    {
        'neovim/nvim-lspconfig',
    },


    ---------------------------------------------------------------------------
    -- LSP Server Management
    ---------------------------------------------------------------------------
    {
        'williamboman/mason.nvim',
        opts = {
            max_concurrent_installers = 4,
            ui = {
                border = "none",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },

            },
            keymaps = {
                toggle_package_expand = "<CR>",         -- Expand a package
                install_package = "i",                  -- Install the package under the current cursor position
                update_package = "u",                   -- Keymap to reinstall/update the package under the current cursor position
                check_package_version = "c",            -- Keymap to check for new version for the package under the current cursor position
                update_all_packages = "U",              -- Keymap to update all installed packages
                check_outdated_packages = "C",          -- Keymap to check which installed packages are outdated
                uninstall_package = "X",                -- Keymap to uninstall a package
                cancel_installation = "<C-c>",          -- Keymap to cancel a package installation
                apply_language_filter = "<C-f>",        -- Keymap to apply language filter
            },
        },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
        },
        opts = {
            ensure_installed = {
                'lua_ls',
            },
        },
    },
}

