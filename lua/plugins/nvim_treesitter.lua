return {
    "nvim-treesitter/nvim-treesitter",

    build = ":TSUpdate",

    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "git_config",
                "gitcommit",
                "gitignore",
                "glsl",
                "html",
                "kdl",
                "json",
                "java",
                "javascript",
                "julia",
                "latex",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "r",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
