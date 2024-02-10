return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local function get_words()
                if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
                    if vim.fn.wordcount().visual_words == 1 then
                        return tostring(vim.fn.wordcount().visual_words) .. " word"
                    elseif not (vim.fn.wordcount().visual_words == nil) then
                        return tostring(vim.fn.wordcount().visual_words) .. " words"
                    else
                        return tostring(vim.fn.wordcount().words) .. " words"
                    end
                else
                    return ""
                end
            end

            require("lualine").setup({
                sections = {
                    lualine_a = {},
                    lualine_x = { "filetype" },
                    lualine_z = { get_words },
                },
                extensions = { "nvim-tree" },
                options = {
                    theme = "tokyonight",
                },
            })
        end,
    },
}
