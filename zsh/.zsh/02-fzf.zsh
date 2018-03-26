# setup fuzzy find

[[ $+commands[fzf] == 1 ]] && {
    export FZF_COMPLETION_TRIGGER='~~'
    export FZF_CTRL_R_OPTS='--sort --exact'
    if type fd > /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

        _fzf_compgen_path() {
          fd --hidden --follow --exclude ".git" . "$1"
        }

        _fzf_compgen_dir() {
          fd --type d --hidden --follow --exclude ".git" . "$1"
        }
    fi

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
