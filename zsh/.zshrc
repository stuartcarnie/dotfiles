# pending move to zplug
# source ~/.zplug/init.zsh

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


for config (~/.zsh/*.zsh) source $config

if [[ -f "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi
