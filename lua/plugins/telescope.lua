return {
	'nvim-telescope/telescope.nvim',

	branch = '0.1.x',

	dependencies = {
		'nvim-lua/plenary.nvim',
	},

	config = function()
		-- set keymaps
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files" })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "live grep" })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'find buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'find help tags' })

		require('telescope').setup({
			-- change some default options
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
					-- preview_width = 100, -- fix width of preview window
				},
				sorting_strategy = "ascending",
				winblend = 0,
			},

			pickers = {
				find_files = { hidden = true }, -- show hidden files in search
			},
		})
	end,
}
