return {
	'nvim-lualine/lualine.nvim', 
	event = "VeryLazy",

	config = function()
		require("lualine").setup({
			options = { 
				-- disable seperators
				section_separators = '', 
				component_separators = '',

                theme = 'dracula',
			}
		})
	end,
}
