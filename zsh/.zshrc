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


# other config

# we always pass these to ls(1)
LS_COMMON="-hBG --color=auto"

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

if [[ -n $(command -v gls) ]]; then
	alias ls="command gls $LS_COMMON"
fi
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc
