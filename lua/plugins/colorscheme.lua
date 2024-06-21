return {
	-- go to after/plugins/color.lua to activate a color scheme

	{ --------------------------------------------------------------------------
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,

		config = function()
			require('catppuccin').setup({
				---
			})
			-- vim.cmd.colorscheme "catppuccin-mocha"
		end
	},

	{ --------------------------------------------------------------------------
		"ellisonleao/gruvbox.nvim",

        config = function()
            require("gruvbox").setup({
				---
            })
        end,
	},

    { --------------------------------------------------------------------------
        "diegoulloao/neofusion.nvim",
        priority = 1000,

        opts = ...,

        config = function()
            require("neofusion").setup({
                transparent_mode = true,
            })
        end,
    },

}

