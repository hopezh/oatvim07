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
        },

		config = function()
            -- set keymaps 
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {}) -- go to definition
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {}) -- go to references
            vim.keymap.set('n', 'K',  vim.lsp.buf.hover,      {}) -- hover to show info
            vim.keymap.set({'n', 'v'}, '<leader>ca',  vim.lsp.buf.code_action, {}) -- hover to show info

            -- import lspconfig
		    local lspconfig = require('lspconfig')

            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})
            lspconfig.tsserver.setup({})
            lspconfig.vimls.setup({})
		end,
	},

	-- {
	-- 	'hrsh7th/cmp-nvim-lsp',
	-- 	config = function()
	-- 		require('cmp').setup({
	-- 			---
	-- 		})
	-- 	end,
	-- },
}
