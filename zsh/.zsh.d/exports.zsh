# Prefer US English and use UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Set default programs
export TERMINAL='alacritty'
export BROWSER='firefox'
export PAGER='less'
export EDITOR='nvim'
export VISUAL="${EDITOR}"

# Search only desired files with fzf
export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden --no-ignore \
    --exclude .git \
    --exclude vendor \
    --exclude node_modules \
    --exclude .terraform \
    --exclude target \
    --exclude bin \
    --exclude build \
    --exclude dist \
    --exclude coverage \
    --exclude .DS_Store'

# Set correct TTY for GPG
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY="$(tty)"

if [[ -n "${WAYLAND_DISPLAY}" ]]; then
    export MOZ_ENABLE_WAYLAND=1
fi
