return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night",
            })
            vim.api.nvim_command("colorscheme tokyonight")
        end,
    },
}
