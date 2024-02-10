# Amend PATH
path+=("${HOME}/.local/bin")
path+=("${HOME}/.node_modules/bin")
path+=("${HOME}/.cargo/bin")
path+=("${HOME}/go/bin")
export PATH

# Prefer US English and use UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Set default programs
export TERMINAL='alacritty'
export BROWSER='brave'
export PAGER='less'
export EDITOR='nvim'
export VISUAL="${EDITOR}"

# Set correct TTY for GPG
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY="$(tty)"

# Set environment variables for Firefox on Wayland
if [[ -n "${WAYLAND_DISPLAY}" ]]; then
    export MOZ_ENABLE_WAYLAND=1
    export XDG_CURRENT_DESKTOP=sway
fi
