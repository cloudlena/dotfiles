return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gdiff" },
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = true,
    },
}
