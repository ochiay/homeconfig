# Source manjaro-zsh-configuration
if [ -f $HOME/.aliases ]; then 
  . $HOME/.aliases 
fi

if [ -f $HOME/.variables ]; then
  . $HOME/.variables
fi

if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
