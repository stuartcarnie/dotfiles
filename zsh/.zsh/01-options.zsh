unsetopt sharehistory
setopt rcquotes
setopt interactivecomments

setopt globdots  # enables dotfiles to be matched, such as autocompletion

# help
unalias run-help 2>/dev/null
autoload run-help
if [[ "$(uname -a 2>/dev/null)" == "Darwin" ]]; then
    # if zsh is not homebrew, this should be disabled
    HELPDIR=/usr/local/share/zsh/help
fi
alias help=run-help

