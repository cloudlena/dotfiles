return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gread", "Gdiff", "Gvdiffsplit" },
        keys = {
            {
                "<Leader>gg",
                ":Git<CR>",
                desc = "Git status",
            },
            {
                "<Leader>gc",
                ":Git commit<CR>",
                desc = "Git commit",
            },
            {
                "<Leader>gm",
                ":Git mergetool | Gvdiffsplit!<CR>",
                desc = "Git three-way merge",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        keys = {
            {
                "<Leader>ga",
                ":Gitsigns stage_hunk<CR>",
                desc = "Git add hunk",
            },
            {
                "<Leader>gu",
                ":Gitsigns undo_stage_hunk<CR>",
                desc = "Git unstage hunk",
            },
            {
                "<Leader>gA",
                ":Gitsigns stage_buffer<CR>",
                desc = "Git add file",
            },
            {
                "<Leader>gU",
                ":Gitsigns reset_buffer<CR>",
                desc = "Git reset file",
            },
            {
                "<Leader>gd",
                ":Gitsigns diffthis<CR>",
                desc = "Git diff",
            },
            {
                "<Leader>gb",
                ":Gitsigns blame_line<CR>",
                desc = "Git blame",
            },
        },
        config = true,
    },
}
