require("nvim-lsp-installer").setup({
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
        capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("auto_fmt", {}),
                pattern = { "*.go", "*.lua" },
                callback = function()
                    lsp_formatting(bufnr)
                end
            })
            nnoremap("<leader>f", function() lsp_formatting(bufnr) end)
            nnoremap("<leader>gd", function() vim.lsp.buf.definition() end)
            nnoremap("K", function() vim.lsp.buf.hover() end)
            nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
            nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
            nnoremap("[d", function() vim.diagnostic.goto_next() end)
            nnoremap("]d", function() vim.diagnostic.goto_prev() end)
            nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
            nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
            nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
            inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
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



local function fix_all(opts)
    opts = opts or {}

    local eslint_lsp_client = util.get_active_client_by_name(opts.bufnr, 'eslint')
    if eslint_lsp_client == nil then
        return
    end

    local request
    if opts.sync then
        request = function(bufnr, method, params)
            eslint_lsp_client.request_sync(method, params, nil, bufnr)
        end
    else
        request = function(bufnr, method, params)
            eslint_lsp_client.request(method, params, nil, bufnr)
        end
    end

    local bufnr = util.validate_bufnr(opts.bufnr or 0)
    request(0, 'workspace/executeCommand', {
        command = 'eslint.applyAllFixes',
        arguments = {
            {
                uri = vim.uri_from_bufnr(bufnr),
                version = vim.lsp.util.buf_versions[bufnr],
            },
        },
    })
end

lspconfig.eslint.setup(config({
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = true
        local group = vim.api.nvim_create_augroup("Eslint", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            pattern = "<buffer>",
            callback = function()
                fix_all({ sync = true, bufnr = 0 })
            end,
            desc = "Run eslint when saving buffer.",
        })
    end,
    capabilities = capabilities,
    settings = {
        validate = 'on',
        packageManager = 'yarn',
        useESLintClass = false,
        codeActionOnSave = {
            enable = false,
            mode = 'all',
        },
        format = true,
        quiet = false,
        onIgnoredFiles = 'off',
        rulesCustomizations = {},
        run = 'onType',
        -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
        -- This path is relative to the workspace folder (root dir) of the server instance.
        -- nodePath = '',
        -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
        workingDirectory = { mode = 'location' },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = 'separateLine',
            },
            showDocumentation = {
                enable = true,
            },
        },
    },
    commands = {
        EslintFixAll = {
            function()
                fix_all { sync = true, bufnr = 0 }
            end,
            description = 'Fix all eslint problems for this buffer',
        },
    },
}))
lspconfig['tsserver'].setup(config())
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




require("lsp_signature").setup()
