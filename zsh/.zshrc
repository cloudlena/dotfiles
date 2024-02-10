# Load the shell dotfiles
# .path can be used to extend `$PATH`.
# .extra can be used for other settings you don’t want to commit.
for file in ~/.zsh.d/*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
