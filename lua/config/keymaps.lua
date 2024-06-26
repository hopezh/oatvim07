-- set leader key --------------------------------------------------------------
vim.g.mapleader = " " -- use the SPACE key as leader key

-- use "jk" to ESC -------------------------------------------------------------
vim.keymap.set("c", "jk", "<ESC>") -- command-line mode
vim.keymap.set("i", "jk", "<ESC>") -- insert mode
vim.keymap.set("o", "jk", "<ESC>") -- operator pending mode
vim.keymap.set("s", "jk", "<ESC>") -- select mode
vim.keymap.set("v", "jk", "<ESC>") -- visual & select mode
vim.keymap.set("x", "jk", "<ESC>") -- visual mode

-- in normal mode, use <leader>+n to clear highlight ---------------------------
vim.keymap.set("n", "<leader>h", ":noh<CR>")


-- temp ========================================================================

-- vim-easy-align --------------------------------------------------------------
-- vim.cmd([[nmap ga <Plug>(EasyAlign)]])
-- vim.cmd([[xmap ga <Plug>(EasyAlign)]])

-- toggle inlay-hints (for neovim >= 0.10) -------------------------------------
-- stylua: ignore
-- if vim.lsp.inlay_hint then
--     vim.keymap.set(
--         "n",
--         "<leader>uh",
--         function()
--             vim.lsp.inlay_hint(0, nil)
--         end,
--         { desc = "Toggle inlay hints" }
--     )
-- end
