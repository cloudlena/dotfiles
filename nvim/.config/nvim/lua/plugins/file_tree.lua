return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<Leader>j",
                "<Cmd>NvimTreeFindFileToggle<CR>",
                desc = "Toggle file tree",
            },
        },
        opts = {
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
