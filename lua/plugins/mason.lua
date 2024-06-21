return {
	'williamboman/mason.nvim',

	lazy = false,

	dependencies = {
		'williamboman/mason-lspconfig.nvim',  -- easy to auto-install lsp needed
	},

	config = function()
		-- import mason
		local mason = require('mason')

		-- impoart mason-lspconfig
		local mason_lspconfig = require('mason-lspconfig')

		-- enable mason and set icons
		mason.setup({
			ui = {
				icons = {
					-- package_installed = "✓",
					-- package_pending = "➜",
					-- package_uninstalled = "✗"
					package_installed = "",
					package_pending = "",
					package_uninstalled = ""
				}
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"html",
				"lua_ls",
				"marksman",
				"pyright",
				"tsserver",
			},

			-- auto-install configured lsp (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

	end,
}

