require("mason").setup()
require("mason-lspconfig").setup({
    automatic_installation = true,
})


local Remap = require("dpr.keymap")
local util = require "lspconfig/util"

local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- Setup nvim-cmp.
local cmp = require("cmp")
local source_mapping = {
    luasnip = "[Snip]",
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    path = "[Path]",
}
local lspkind = require("lspkind")

cmp.setup({
    snippet = {
        expand = function(args)
            -- For `vsnip` user.
            -- vim.fn["vsnip#anonymous"](args.body)

            -- For `luasnip` user.
            require("luasnip").lsp_expand(args.body)

            -- For `ultisnips` user.
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),

    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            local menu = source_mapping[entry.source.name]
            vim_item.menu = menu
            return vim_item
        end,
    },
    experimental = {
        ghost_text = { hl_group = 'TSTagDelimiter' },
    },
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "buffer", max_item_count = 3 },
        { name = 'rg', max_item_count = 3 },
        { name = 'spell' },
    },
})


-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
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


local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- return client.name ~= "volar"
            return true
        end,
        bufnr = bufnr,
    })
end


local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("auto_fmt", {}),
                pattern = { "*.go", "*.lua" },
                callback = function()
                    vim.lsp.buf.formatting_sync()
                end
            })
            nnoremap("<leader>f", function() vim.lsp.buf.formatting_sync() end)
            nnoremap("<leader>gd", function() vim.lsp.buf.definition() end)
            nnoremap("<leader>gD", function() vim.lsp.buf.declaration() end)
            nnoremap("<leader>gT", function() vim.lsp.buf.type_definition() end)

            nnoremap("<space>rr", function() vim.cmd('LspRestart') end)
            nnoremap("[d", function() vim.diagnostic.goto_next() end)
            nnoremap("]d", function() vim.diagnostic.goto_prev() end)
            nnoremap("<leader>ca", function() vim.lsp.buf.code_action() end)
            nnoremap("<leader>re", function() vim.lsp.buf.rename() end)
        end,
    }, _config or {})
end

local lspconfig = require('lspconfig')
lspconfig.gopls.setup(config({
    cmd = { "gopls", "serve" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            gofumpt = true,
            --usePlaceholders = false,
            semanticTokens = true,
            hoverKind = 'Structured',
            annotations = {
                bounds = true,
                escape = true,
                inline = true,
                ['nil'] = true,
            },
            linkTarget = 'pkg.go.dev',
            linksInHover = true,
            -- importShortcut = 'Both',
            --see https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
            analyses = {
                fieldalignment = true,
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedvariable = true,
                unusedwrite = true,
                useany = true,
            },
            codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = false,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            staticcheck = true,
        },
    },
}))


lspconfig['tsserver'].setup(config())
require("typescript").setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
    },
    server = { -- pass options to lspconfig's setup method
        on_attach = config().on_attach
    },
})
lspconfig['golangci_lint_ls'].setup(config())
lspconfig['ccls'].setup(config())
lspconfig['cssls'].setup(config())
lspconfig['grammarly'].setup(config())
lspconfig['vimls'].setup(config())
lspconfig['volar'].setup(config())
lspconfig['cssmodules_ls'].setup(config())
lspconfig['sqlls'].setup(config())
lspconfig['sqls'].setup(config())
lspconfig['bashls'].setup(config())
lspconfig['sumneko_lua'].setup(config({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}))

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}

require("symbols-outline").setup(opts)

local snippets_paths = function()
    local plugins = { "friendly-snippets" }
    local paths = {}
    local path
    local root_path = vim.env.HOME .. "/.vim/plugged/"
    for _, plug in ipairs(plugins) do
        path = root_path .. plug
        if vim.fn.isdirectory(path) ~= 0 then
            table.insert(paths, path)
        end
    end
    return paths
end
--print(vim.inspect(snippets_paths()))
require("luasnip.loaders.from_vscode").lazy_load({
    paths = snippets_paths(),
    include = nil, -- Load all languages
    exclude = {},
})

-- Set up null-ls
local use_null = true
if use_null then
    local augroup = vim.api.nvim_create_augroup("auto_fmt", {})
    local null_ls = require("null-ls")
    local b = null_ls.builtins
    null_ls.setup {
        sources = {
            -- b.diagnostics.eslint,
            -- b.completion.spell,
            b.diagnostics.eslint_d,
            b.formatting.eslint_d,
        },
        debug = true,
        -- format on save
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.formatting_sync({ bufnr = bufnr })
                    end,
                })
            end
        end,
    }
end


require("lsp_signature").setup()
