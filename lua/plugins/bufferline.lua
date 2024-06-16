return {
	'akinsho/bufferline.nvim', 

	version = "*", 

	event = "VeryLazy",

	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},


  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  },

  -- bufferline docs:
  -- https://github.com/akinsho/bufferline.nvim/blob/main/doc/bufferline.txt
  config = function()
	  require("bufferline").setup({
		  options = {
			indicator = {
				-- icon = '▎', -- this should be omitted if indicator style is not 'icon'
				-- style = 'icon' | 'underline' | 'none',
				style = 'underline',
			},

            -- separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
            separator_style = "thick",  

			-- move tabs aside to accommadate neo-tree
			offsets = {
				{
				  filetype = "neo-tree",
				  text = "Neo-tree",
				  -- text = function()
				  --  return vim.fn.getcwd()
				  -- end, 
				  highlight = "Directory",
				  text_align = "left",
				},
			},

			-- hover event
			-- need to set "vim.opt.mousemoveevent = true" in options.lua
			hover = {
				enabled = true,
				delay = 100,
				reveal = { 'close' }
			},

			-- show diagnostic info
			diagnostic = "nvim_lsp",
		  }
	  })
  end,
}
