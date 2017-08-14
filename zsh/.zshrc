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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Don't search files which are gitignored in FZF
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
