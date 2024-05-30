# NOTE: This script tests for INTELLIJ_ENVIRONMENT_READER and omits
# scripts that are only required for interactive sessions

if [ ! -v INTELLIJ_ENVIRONMENT_READER ]; then
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    # pending move to zplug
    # source ~/.zplug/init.zsh

    # Source Prezto.
    if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
      source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
    fi

    for config (~/.zsh/*.zsh) source $config
fi

# Powerline10k config
# See: https://github.com/romkatv/powerlevel10k#prezto

POWERLEVEL9K_DISABLE_RPROMPT=false
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)

# other config

# we always pass these to ls(1)
LS_COMMON="-hBG --color=auto"

if [ ! -v INTELLIJ_ENVIRONMENT_READER ]; then
    # if the dircolors utility is available, set that up too
    dircolors="$(command -v gdircolors dircolors | head -1)"
    if [[ -n "$dircolors" ]]; then
        COLORS=/etc/DIR_COLORS
        test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
        test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
        test ! -e "$COLORS"               && COLORS=
        eval $($dircolors --sh $COLORS)
        unset COLORS
    fi
    unset dircolors

    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /usr/local/bin/mc mc

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/stuartcarnie/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/stuartcarnie/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/stuartcarnie/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/stuartcarnie/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Source .zshrc.local last

if [[ -f "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi
