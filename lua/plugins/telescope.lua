return {
    { --------------------------------------------------------------------------
        'nvim-telescope/telescope.nvim',

        branch = '0.1.x',

        dependencies = {
            'nvim-lua/plenary.nvim',
        },

        config = function()
            -- set keymaps
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'find buffers' })
            vim.keymap.set('n', '<leader>fc', builtin.command_history, { desc = 'find cmd history' })
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "live grep" })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'find help tags' })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'find keymaps' })
            vim.keymap.set('n', '<leader>fo', builtin.colorscheme, { desc = 'find colorscheme' })
            vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'find recent files' })

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
    },

    { --------------------------------------------------------------------------
        -- show code action etc in a selection ui
        'nvim-telescope/telescope-ui-select.nvim',

        config = function()
             -- This is your opts table
            require("telescope").setup {
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown {
                    -- even more opts
                  }
                }
              }
            }
            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end,
    },
}
