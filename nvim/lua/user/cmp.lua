local cmp_found, cmp = pcall(require, 'cmp')
if not cmp_found or cmp == nil then
    print('cmp not found')
    return
end

local luasnip_found, luasnip = pcall(require, 'luasnip')
if not luasnip_found or luasnip == nil then
    print('luasnip not found')
end

cmp.setup {
    snippet = {
        expand = function(args)
            if luasnip ~= nil then
                luasnip.lsp_expand(args.body)
            end
        end
    },

    --window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
    --},

    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },


    --documentation = {
        --border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --},

    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm{
            behavior = cmp.ConfirmBehavior.Insert,
            select = true, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        ['<Tab>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip == nil then
                    fallback()
                elseif luasnip.expandable() then
                    luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
            {'i', 's'}
        ),
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        --{ name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

