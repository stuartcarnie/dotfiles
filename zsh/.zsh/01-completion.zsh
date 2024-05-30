if is-callable 'carapace'; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
else
  autoload bashcompinit
  bashcompinit
  fpath=(~/.zsh/completion $fpath)
fi

# [[ $+commands[kubectl] == 1 ]] && {
#     source <(kubectl completion zsh)
# }
