# Path to your oh-my-zsh installation.
case "$(uname)" in
'Linux')
    export ZSH=/usr/share/oh-my-zsh
    ;;
'Darwin')
    export ZSH=$HOME/.oh-my-zsh
    ;;
esac

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="zhann"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
#
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# update oh-my-zsh bi weekly and other useful helpers
source $ZSH/oh-my-zsh.sh

# Autocompletions for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
