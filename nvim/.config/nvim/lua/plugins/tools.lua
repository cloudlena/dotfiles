local tools = require("config.tools")

return {
    {
        "williamboman/mason.nvim",
        lazy = true,
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy",
        opts = {
            ensure_installed = tools.lsp,
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy",
        config = function()
            local mason_null_ls = require("mason-null-ls")

            local null_ls_tools = tools.linter
            for _, f in pairs(tools.formatter) do
                table.insert(null_ls_tools, f)
            end

            mason_null_ls.setup({
                ensure_installed = null_ls_tools,
                automatic_setup = true,
            })
            mason_null_ls.setup_handlers()
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy",
        config = function()
            local mason_dap = require("mason-nvim-dap")

            mason_dap.setup({
                ensure_installed = tools.dap,
                automatic_setup = true,
            })
            mason_dap.setup_handlers()
        end,
    },
    {
        "RubixDev/mason-update-all",
        dependencies = { "williamboman/mason.nvim" },
        cmd = { "MasonUpdateAll" },
        config = true,
    },
}
