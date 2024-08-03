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

}
