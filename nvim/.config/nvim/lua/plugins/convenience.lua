return {
    -- Automatically set indent settings
    { "tpope/vim-sleuth", event = "VeryLazy" },

    -- Edit surrounds
    { "tpope/vim-surround", event = "VeryLazy" },

    -- Allow to repeat plugin commands
    { "tpope/vim-repeat", event = "VeryLazy" },

    -- Autoclose pairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

    -- Toggle comments
    { "numToStr/Comment.nvim", keys = { "gc", { "gc", mode = "v" } }, config = true },
}
