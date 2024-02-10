return {
    {
        "will133/vim-dirdiff",
        cmd = { "DirDiff" },
        config = function()
            vim.g.DirDiffExcludes =
                ".DS_Store,.git,.terraform,.gradle,bin,build,coverage,dist,node_modules,target,vendor"
        end,
    },
}
