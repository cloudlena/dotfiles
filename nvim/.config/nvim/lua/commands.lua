-- Strip trailing whitespaces on save
vim.cmd("autocmd BufWritePre * %s/\\s\\+$//e")

-- Enable spell checking for certain file types
vim.cmd("autocmd BufRead,BufNewFile *.txt,*.md,*.tex setlocal spell")
