return {
	{
		"echasnovski/mini.align",
		version = false,
		event = 'VeryLazy',

		config = function()
			require("mini.align").setup({
				mappings = {
					start              = '<leader>ma',
					start_with_preview = '<leader>mA',
				},
			})
		end,
	},

	{
		'echasnovski/mini.pairs',
		version = '*',
		event = 'VeryLazy',

		config = function()
			require('mini.pairs').setup({})
		end,
	},

	{
		'echasnovski/mini.surround',
		version = '*',
		event = 'VeryLazy',

		config = function()
			require('mini.surround').setup({
		        mappings = {
				    add            = "<leader>msa", -- Add surrounding in Normal and Visual modes
				    delete         = "<leader>msd", -- Delete surrounding
				    find           = "<leader>msf", -- Find surrounding (to the right)
				    find_left      = "<leader>msF", -- Find surrounding (to the left)
				    highlight      = "<leader>msh", -- Highlight surrounding
				    replace        = "<leader>msr", -- Replace surrounding
				    update_n_lines = "<leader>msn", -- Update `n_lines`
				},
			})
		end,

	},
}
