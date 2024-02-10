return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<Leader>j",
                function()
                    require("nvim-tree").toggle(true)
                end,
                "Toggle file tree",
            },
        },
        config = {
            filters = {
                custom = { "^.DS_Store$", "^.git$" },
            },
            renderer = {
                icons = {
                    show = {
                        git = false,
                    },
                },
            },
        },
    },
}
