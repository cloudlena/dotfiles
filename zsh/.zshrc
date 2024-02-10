# Load the shell dotfiles
# extra.zsh can be used for settings you don’t want to commit.
for file in ~/.zsh.d/*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# History navigation commands
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
