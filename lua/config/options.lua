local opt = vim.opt

opt.autoindent = true
opt.background = "dark"
opt.colorcolumn = "80" -- highlight the 80th column, nil when virt-column.nvim is used
opt.expandtab = true
-- opt.fileformat = "unix" -- specify file format to remove the "^M" char at line end

opt.guicursor =
    "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- blinking cursor

opt.list = false
opt.mousemoveevent = true
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.showtabline = 2 -- always show tab header
opt.signcolumn = "yes:3" -- always show signcolumn, max width=3
opt.smarttab = true
opt.softtabstop = 4
opt.tabstop = 4
opt.undofile = false -- stop unlimited undo to even changes made in previous session

vim.cmd("set noswapfile") -- no swap file

vim.o.timeoutlen = 100 -- enable quicker response of which-key

-- temp ========================================================================

-- stop auto format on save ----------------------------------------------------
-- vim.g.autoformat = false -- globally
-- vim.b.autoformat = false -- buffer-local

-- LazyVim automatically configures lazygit: -----------------------------------
--  * theme, based on the active colorscheme.
--  * editorPreset to nvim-remote
--  * enables nerd font icons
-- vim.g.lazygit_config = false  -- Set to false to disable.
