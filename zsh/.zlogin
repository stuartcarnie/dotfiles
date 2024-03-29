#
# Executes commands at login, after zshrc.
#

# if [[ -v GOODPATH ]]; then
#     # MacOS workaround sneaky path_helper in /etc/zprofile
#     export PATH=$GOODPATH
# fi

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /opt/homebrew/bin
  /usr/local/{bin,sbin}
  $path
)

typeset -gU PATH path

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

if [[ "${TERM_PROGRAM}" == "iTerm.app" ]]; then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

if [[ -f "${ZDOTDIR:-$HOME}/.zlogin.local" ]]; then
    source "${ZDOTDIR:-$HOME}/.zlogin.local"
fi
