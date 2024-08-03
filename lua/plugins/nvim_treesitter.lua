return {
    "nvim-treesitter/nvim-treesitter",

    dev = false,

    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },

    run = ":TSUpdate",

    config = function()
        require('nvim-treesitter.configs').setup({
            auto_install = true,

            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "dot",
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
                "latex", -- requires tree-sitter-cli (installed automatically via Mason)
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "mermaid",
                "norg",
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
