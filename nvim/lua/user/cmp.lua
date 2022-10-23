local cmp_found, cmp = pcall(require, 'cmp')
if not cmp_found or cmp == nil then
    print('cmp not found')
    return
end

local luasnip_found, luasnip = pcall(require, 'luasnip')
if not luasnip_found or luasnip == nil then
    print('luasnip not found')
end


-------------------------------------------------------------------------------
-- Configuration
-------------------------------------------------------------------------------

local item_kind_to_icon = {
  Class = "",
  Color = "",
  Constant = "𝝿",
  Constructor = "𝞁",
  Enum = "𝝚",
  EnumMember = "𝝴",
  Event = "",
  Field = "𝞅",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "𝝻",
  Module = "",
  Operator = "",
  Property = "",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "𝝩",
  TypeParameter = "",
  Unit = "",
  Value = "𝝼",
  Variable = "𝞌",
}


-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------

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

    experimental = {
        ghost_text = true,
        --native_menu = false,
    },

    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s", item_kind_to_icon[vim_item.kind])
            vim_item.menu = ({
                buffer = '[Buffer]',
                calc = '[Calc]',
                luasnip = '[Snippet]',
                nvim_lsp = '[LSP]',
                nvim_lua = '[NVIM_LUA]',
                path = '[Path]',
                treesitter = '[Treesitter]',
                zsh = '[Zsh]',
            })[entry.source.name]
            return vim_item
        end,
    },

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
                    return
                end

                if luasnip ~= nil then
                    if luasnip.expandable() then
                        luasnip.expand()
                        return
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                        return
                    end
                end

                fallback()
            end,
            {'i', 's'}
        ),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
                return
            end

            if luasnip ~= nil and luasnip.jumpable(-1) then
                luasnip.jump(-1)
                return
            end

            fallback()
        end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({'/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'cmdline' }
    }, {
        { name = 'path' }
    })
})

