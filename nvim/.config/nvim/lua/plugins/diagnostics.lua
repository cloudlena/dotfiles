return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<Leader>s", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Toggle diagnostics" },
        },
        config = true,
    },
}
