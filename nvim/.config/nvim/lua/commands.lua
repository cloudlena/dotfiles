local opts = {noremap = true, silent = true}

-- LSP actions
vim.api
    .nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>',
                        opts)
vim.api
    .nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', '<space>f',
                        '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- Toggle fuzzy file search
vim.api.nvim_set_keymap('n', '<C-P>',
                        '<Cmd>lua require("telescope.builtin").find_files{ find_command = { "fd", "--type=f", "--type=l", "--hidden", "--no-ignore", "--exclude=.DS_Store", "--exclude=.git", "--exclude=.terraform", "--exclude=.gradle", "--exclude=bin", "--exclude=build", "--exclude=coverage", "--exclude=dist", "--exclude=node_modules", "--exclude=target", "--exclude=vendor" }}<CR>',
                        opts)

-- Toggle fuzzy search across project
vim.api.nvim_set_keymap('n', '\\', '<Cmd>Telescope live_grep<CR>', opts)

-- Toggle file tree
vim.api.nvim_set_keymap('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', opts)

-- Toggle diagnostics list
vim.api.nvim_set_keymap('n', '<C-s>', '<Cmd>TroubleToggle<CR>', opts)

-- Strip trailing whitespaces on save
vim.cmd 'autocmd BufWritePre * %s/\\s\\+$//e'
-- Enable spell checking for certain file types
vim.cmd 'autocmd BufRead,BufNewFile *.md,*.tex setlocal spell'
