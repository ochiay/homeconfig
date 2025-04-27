# Use powerline
ZSH_THEME="nicoulaj" # "robbyrussell"
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"

if [[ -d $HOME/.oh-my-zsh ]]; then
    export ZSH="$HOME/.oh-my-zsh"
    plugins=(git)
    source $ZSH/oh-my-zsh.sh
fi
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
# aliases 
if [ -f $HOME/.aliases ]; then
  . $HOME/.aliases
fi
# variables
if [ -f $HOME/.variables ]; then
  . $HOME/.variables
fi
