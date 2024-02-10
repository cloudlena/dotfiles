# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Load the shell dotfiles
# extra.zsh can be used for settings you don’t want to commit.
for file in ~/.zsh.d/*.zsh; do
  source "$file"
done

# History navigation commands
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Start tmux for every terminal session
[[ -z "$TMUX" && $(tty) != /dev/tty[0-9] ]] && { tmux || exec tmux new-session && exit }
