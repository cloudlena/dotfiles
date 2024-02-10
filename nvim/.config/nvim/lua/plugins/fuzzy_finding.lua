return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = { "Telescope" },
        keys = {
            {
                "<Leader><space>",
                "<Cmd>Telescope find_files find_command=fd,--type=file,--type=symlink,--hidden,--no-ignore,--exclude=.DS_Store,--exclude=.git,--exclude=.terraform,--exclude=.gradle,--exclude=.svelte-kit,--exclude=bin,--exclude=build,--exclude=coverage,--exclude=dist,--exclude=node_modules,--exclude=target,--exclude=vendor,--exclude=venv,--exclude=__pycache__<CR>",
                desc = "Find files",
            },
            { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = require("telescope.actions").close,
                        },
                    },
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
}
