PREFIX=`brew --prefix`

# Setup fzf
# ---------
if [[ ! "$PATH" == *$PREFIX/opt/fzf/bin* ]]; then
  export PATH="$PATH:$PREFIX/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$PREFIX/opt/fzf/shell/key-bindings.zsh"

