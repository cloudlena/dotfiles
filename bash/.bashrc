# Add nano as default editor
export EDITOR=nano
export TERMINAL=lxterminal
export BROWSER=firefox
# Gtk themes 
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Go Env
export GOPATH=$HOME/go

alias ls='ls --color=auto'
alias pacu='sudo pacman -Syu --noconfirm && yaourt -Syua --noconfirm && sudo npm update -g'
alias npmu='npm-check-updates -u && npm update && bower update'

#[ -n "$PS1" ] && source ~/.bash_profile;
