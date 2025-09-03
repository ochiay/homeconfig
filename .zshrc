ZSH_THEME="nicoulaj"  # robbyrussell nicoulaj agnoster
USE_POWERLINE="true"
HAS_WIDECHARS="true"

if [[ -d $HOME/.oh-my-zsh ]]; then
    export ZSH="$HOME/.oh-my-zsh"
    plugins=(git sudo z zsh-autosuggestions python tmux colorize)
    source $ZSH/oh-my-zsh.sh
fi

# Source manjaro-zsh-configuration
if [[ -e ~/.zshrc_manjaro.sh ]]; then
  source ~/.zshrc_manjaro.sh
fi

# # Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  #source /usr/share/zsh/manjaro-zsh-prompt
fi

# aliases 
if [ -f $HOME/.aliases ]; then
  . $HOME/.aliases
fi
# variables
if [ -f $HOME/.variables ]; then
  . $HOME/.variables
fi
