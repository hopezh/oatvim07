-- activate a colorscheme ------------------------------------------------------
-- vim.cmd("colorscheme catppuccin")
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme neofusion")
-- vim.cmd("colorscheme tokyonight")


-- toggle dark/light theme -----------------------------------------------------
-- Thanks to kkafar:
-- https://github.com/folke/tokyonight.nvim/discussions/426#discussioncomment-7102103

local function toggle_theme()
    if vim.opt.background:get() == "dark" then
        vim.opt.background = "light"
    -- vim.cmd("colorscheme tokyonight-day")
    else
        vim.opt.background = "dark"
        -- vim.cmd("colorscheme tokyonight-moon")
    end
end

-- stylua: ignore
vim.keymap.set(
    "n",
    "<leader>zt",
    toggle_theme,
    { desc = "Toggle dark/light theme" }
)


-- change the color of ColorColumn ---------------------------------------------
-- !!! must disable virt-column
vim.cmd("highlight ColorColumn ctermbg=0 guibg=#222222")

