local ms = vim.lsp.protocol.Methods
local handlers = require('misc.handlers')

return {
    { -- a UI to install lsp servers locally -----------------------------------
        'williamboman/mason.nvim',

        keys = {
            {
                "<leader>cm",
                "<cmd>Mason<cr>",
                desc = "Mason",
            },
        },

        config = function()
            -- import mason
            local mason = require('mason')

            -- enable mason and set icons
            mason.setup({
                ui = {
                    icons = {
                        -- package_installed = "✓",
                        -- package_pending = "➜",
                        -- package_uninstalled = "✗"
                        package_installed = "",
                        package_pending = "",
                        -- package_uninstalled = ""
                        package_uninstalled = ""
                    }
                },
            })
        end,
    },

    { -- ensure the installation of some lsp -----------------------------------
        'williamboman/mason-lspconfig.nvim',

        config = function()
            -- impoart mason-lspconfig
            local mason_lspconfig = require('mason-lspconfig')

            mason_lspconfig.setup({
                -- list of "lspconfig" server names for mason to install
                -- check: https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
                -- for the link btw "lspconfig server name" and "mason.nvim package name"

                ensure_installed = {
                    "cssls",
                    "eslint",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "marksman",
                    "pyright",
                    "tsserver",
                    "vimls",
                    "yamlls",
                },
            })

        end,
    },

	{ -- link locally installed lsp and neovim ---------------------------------
		'neovim/nvim-lspconfig',

        -- add dependencies to avoid error on spawning lsp server
        dependencies = {
            { 'williamboman/mason.nvim', },

            {
                'williamboman/mason-lspconfig.nvim',

                config = function()
                    ---
                end,
            },

            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

            {
                -- nice loading notifications
                -- PERF: but can slow down startup
                'j-hui/fidget.nvim',
                enabled = false,
                opts = {},
            },
        },

		config = function()
            -- set keymaps 
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {}) -- go to definition
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {}) -- go to references
            vim.keymap.set('n', 'K',  vim.lsp.buf.hover,      {}) -- hover to show info
            vim.keymap.set({'n', 'v'}, '<leader>ca',  vim.lsp.buf.code_action, {}) -- hover to show info

            -- import lspconfig
		    local lspconfig = require('lspconfig')
            local util = require('lspconfig.util')

            require('mason').setup()
            require('mason-lspconfig').setup {
                automatic_installation = true,
            }
            require('mason-tool-installer').setup {
                ensure_installed = {
                    'black',
                  'stylua',
                  'shfmt',
                  'isort',
                  'tree-sitter-cli',
                  'jupytext',
                },
            }

            -- create autcmd for LspAttach
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                  local function map(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                  end
                  local function vmap(keys, func, desc)
                    vim.keymap.set('v', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                  end

                  local client = vim.lsp.get_client_by_id(event.data.client_id)
                  assert(client, 'LSP client not found')

                  ---@diagnostic disable-next-line: inject-field
                  client.server_capabilities.document_formatting = true

                  map('gS', vim.lsp.buf.document_symbol, '[g]o so [S]ymbols')
                  map('gD', vim.lsp.buf.type_definition, '[g]o to type [D]efinition')
                  map('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
                  map('K', vim.lsp.buf.hover, '[K] hover documentation')
                  map('gh', vim.lsp.buf.signature_help, '[g]o to signature [h]elp')
                  map('gI', vim.lsp.buf.implementation, '[g]o to [I]mplementation')
                  map('gr', vim.lsp.buf.references, '[g]o to [r]eferences')
                  map('[d', vim.diagnostic.goto_prev, 'previous [d]iagnostic ')
                  map(']d', vim.diagnostic.goto_next, 'next [d]iagnostic ')
                  map('<leader>ll', vim.lsp.codelens.run, '[l]ens run')
                  map('<leader>lR', vim.lsp.buf.rename, '[l]sp [R]ename')
                  map('<leader>lf', vim.lsp.buf.format, '[l]sp [f]ormat')
                  vmap('<leader>lf', vim.lsp.buf.format, '[l]sp [f]ormat')
                  map('<leader>lq', vim.diagnostic.setqflist, '[l]sp diagnostic [q]uickfix')
                end,
            })

            local lsp_flags = {
                allow_incremental_sync = true,
                debounce_text_changes = 150,
            }

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
                vim.lsp.handlers.hover, { border = require('misc.style').border })
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
                vim.lsp.handlers.signature_help, { border = require('misc.style').border })
            vim.lsp.handlers[ms.textDocument_definition] = handlers.telescope_handler_factory(
                ms.textDocument_definition, "Definition")
            vim.lsp.handlers[ms.textDocument_typeDefinition] = handlers.telescope_handler_factory(
                ms.textDocument_typeDefinition, "Type Definition")
            vim.lsp.handlers[ms.textDocument_references] = handlers.telescope_handler_factory(
                ms.textDocument_references, "References")
            vim.lsp.handlers[ms.textDocument_implementation] = handlers.telescope_handler_factory(
                ms.textDocument_implementation, "Implementations")
            vim.lsp.handlers[ms.textDocument_documentSymbol] = handlers.telescope_handler_factory(
                ms.textDocument_documentSymbol, "Document Symbols")

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            capabilities.textDocument.completion.completionItem.snippetSupport = true


            -- config individual lsp 
            lspconfig.lua_ls.setup({})

            -- also need the following to $home/.config/marksman/config.toml:
            -- [core]
            -- markdown.file_extensions = ["md", "markdown", "qmd"]
            lspconfig.marksman.setup {
                capabilities = capabilities,
                filetypes = { 'markdown', 'quarto' },
                root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml'),
            }

            -- See https://github.com/neovim/neovim/issues/23291
            -- disable lsp watcher.
            -- Too lags on linux for python projects
            -- because pyright and nvim both create too many watchers otherwise
            if capabilities.workspace == nil then
                capabilities.workspace = {}
                capabilities.workspace.didChangeWatchedFiles = {}
            end
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

            lspconfig.pyright.setup({
                capabilities = capabilities,
                flags = lsp_flags,
                settings = {
                  python = {
                    analysis = {
                      autoSearchPaths = true,
                      useLibraryCodeForTypes = true,
                      diagnosticMode = 'workspace',
                    },
                  },
                },
                root_dir = function(fname)
                  return util.root_pattern(
                      '.git',
                      'setup.py',
                      'setup.cfg',
                      'pyproject.toml',
                      'requirements.txt'
                  )(fname) or util.path.dirname(fname)
                end,
            })

            lspconfig.tsserver.setup({
                capabilities = capabilities,
                flags = lsp_flags,
                filetypes = { 'js', 'javascript', 'typescript', 'ojs' },
            })

            lspconfig.vimls.setup({})
		end,
	},

	{ -- completion ------------------------------------------------------------
		'hrsh7th/nvim-cmp',

        event = 'InsertEnter',

        dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-nvim-lsp-signature-help',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-calc',
          'hrsh7th/cmp-emoji',
          'saadparwaiz1/cmp_luasnip',
          'f3fora/cmp-spell',
          'ray-x/cmp-treesitter',
          'kdheepak/cmp-latex-symbols',
          'jmbuhr/cmp-pandoc-references',
          'L3MON4D3/LuaSnip',
          'rafamadriz/friendly-snippets',
          'onsails/lspkind-nvim',
          'jmbuhr/otter.nvim',
        },

		config = function()

        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local lspkind = require 'lspkind'

        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
        end

        cmp.setup {
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },

            completion = { completeopt = 'menu,menuone,noinsert' },

            mapping = {
              ['<C-f>'] = cmp.mapping.scroll_docs(-4),

              ['<C-d>'] = cmp.mapping.scroll_docs(4),

              ['<C-n>'] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                  fallback()
                end
              end, { 'i', 's' }),

              ['<C-p>'] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { 'i', 's' }),

              ['<C-e>'] = cmp.mapping.abort(),

              ['<c-y>'] = cmp.mapping.confirm { select = true },

              ['<CR>'] = cmp.mapping.confirm { select = true },

              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),

              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end, { 'i', 's' }),

              ['<C-l>'] = cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { 'i', 's' }),

              ['<C-h>'] = cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { 'i', 's' }),
            },

            autocomplete = false,

            ---@diagnostic disable-next-line: missing-fields
            formatting = {
              format = lspkind.cmp_format {
                mode = 'symbol',
                menu = {
                  otter = '[🦦]',
                  nvim_lsp = '[LSP]',
                  nvim_lsp_signature_help = '[sig]',
                  luasnip = '[snip]',
                  buffer = '[buf]',
                  path = '[path]',
                  spell = '[spell]',
                  pandoc_references = '[ref]',
                  tags = '[tag]',
                  treesitter = '[TS]',
                  calc = '[calc]',
                  latex_symbols = '[tex]',
                  emoji = '[emoji]',
                },
              },
            },
            sources = {
              -- { name = 'otter' }, -- for code chunks in quarto
              { name = 'path' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'nvim_lsp' },
              { name = 'luasnip', keyword_length = 3, max_item_count = 3 },
              { name = 'pandoc_references' },
              { name = 'buffer', keyword_length = 5, max_item_count = 3 },
              { name = 'spell' },
              { name = 'treesitter', keyword_length = 5, max_item_count = 3 },
              { name = 'calc' },
              { name = 'latex_symbols' },
              { name = 'emoji' },
            },
            view = {
              entries = 'native',
            },
            window = {
              documentation = {
                border = require('misc.style').border,
              },
            },
          }

          -- for friendly snippets
          require('luasnip.loaders.from_vscode').lazy_load()

          -- for custom snippets
          require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snips' } }

          -- link quarto and rmarkdown to markdown snippets
          luasnip.filetype_extend('quarto', { 'markdown' })
          luasnip.filetype_extend('rmarkdown', { 'markdown' })

        end,
    },
}
