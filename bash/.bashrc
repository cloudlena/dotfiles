[ -n "$PS1" ] && source ~/.bash_profile;

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Don't search files which are gitignored in FZF
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
