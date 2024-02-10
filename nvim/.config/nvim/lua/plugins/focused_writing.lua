return {
    {
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" },
        opts = {
            window = {
                backdrop = 1,
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                },
            },
        },
    },
    { "folke/twilight.nvim", config = true, lazy = true },
}
