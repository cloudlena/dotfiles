# Prefer US English and use UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Set default programs
export TERMINAL='alacritty'
export BROWSER='firefox'
export EDITOR='nvim'
export VISUAL="${EDITOR}"

# Search only desired files with fzf
export FZF_DEFAULT_COMMAND='rg --smart-case --files --no-ignore --hidden --follow --glob "!.DS_Store" --glob "!.git/*" --glob "!vendor/*" --glob "!node_modules/*" --glob "!.terraform/*" --glob "!bin/*" --glob "!build/*" --glob "!coverage/*" --glob "!dist/*" --glob "!target/*"'

# Set correct TTY for GPG
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY="$(tty)"
