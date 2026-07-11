use std/util "path add"

$env.CARAPACE_BRIDGES = 'zsh,fish'

let carapace_completer = {|spans|
    # if the current command is an alias, get it's expansion
    let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)

    let spans = (if $expanded_alias != null {
        # put the first word of the expanded alias first in the span
        $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
    } else {
        $spans | skip 1 | prepend ($spans.0)
    })

    carapace $spans.0 nushell ...$spans | from json
}

mkdir ($nu.data-dir | path join "vendor/autoload")

$env.config.abbreviations = {
    l: "ls"
    ll: "ls -l"
    la: "ls -al"
}

# yazi is also y
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

$env.config.show_banner = true
$env.config.buffer_editor = "nvim"
$env.config.completions.external = {
    enable: true,
    completer: $carapace_completer,
}
$env.config.use_kitty_protocol = true
$env.config.completions.algorithm = "fuzzy"

$env.config.history = {
    file_format: sqlite
    max_size: 5_000_000
    sync_on_enter: true
    isolation: true
}

# Configure the command line hinter to use atuin for suggestions
$env.config.hinter = {
    closure: {|ctx|
        if ($ctx.line | str length) == 0 {
            null
        } else {
            # First try to get a candidate from the directory history.
            #
            # NOTE: Depends on https://github.com/atuinsh/atuin/pull/3535
            let candidate = (try {
                    ^atuin search --filter-modes directory,session,global --limit 1 --search-mode prefix --cmd-only $ctx.line
                    | lines
                    | first
                } catch {
                    null
                })

            if $candidate == null or not ($candidate | str starts-with $ctx.line) {
                null
            } else {
                ($candidate | str substring (($ctx.line | str length))..)
            }
        }
    }
}

$env.EDITOR = "nvim"

$env.config.hooks.display_output = { if (term size).columns >= 100 { table -e --icons } else { table } }

# use homebrew sqlite3
#
# NOTE: We don't use `brew --prefix sqlite3` as it takes 22ms to execute this command
path add "/opt/homebrew/opt/sqlite/bin"

source scripts/macos.nu

ulimit -n 10000

# Configure nu_plugin_skim
# See: https://github.com/idanarye/nu_plugin_skim/tree/main
$env.SKIM_DEFAULT_OPTIONS = "--bind ctrl-o:preview-page-up,ctrl-p:preview-page-down,ctrl-t:toggle-preview"

# Conditionally update a file with the output of a generator closure, only if the content has changed
# or the file doesn't exist. This is useful for autoload scripts and completions that need to be
# updated when their generators change, but we want to avoid unnecessary writes.
def update-script [base_path: path, name: string, generator: closure] {
    let base_path = ($nu.data-dir | path join $base_path)
    if not ($base_path | path exists) {
        mkdir $base_path
    }

    let init_path = ($base_path | path join $name)
    let content = (do $generator | decode utf-8)
    if (not ($init_path | path exists) or $content != (open $init_path | decode utf-8)) {
        print $"updating ($init_path)"
        $content | save -f $init_path
    }
}

def update-autoload [name: string, generator: closure] {
    update-script vendor/autoload $name $generator
}

# configure starship prompt
if (which starship | is-not-empty) {
    update-autoload "starship.nu" { starship init nu }

    # avoid same PROMPT_INDICATOR
    $env.PROMPT_INDICATOR = { "" }
    $env.PROMPT_INDICATOR_VI_INSERT = { ": " }
    $env.PROMPT_INDICATOR_VI_NORMAL = { "〉" }
    $env.PROMPT_MULTILINE_INDICATOR = { "::: " }
}

## configure atuin

if (which atuin | is-not-empty) {
    #update-autoload "atuin.nu" { atuin init nu }

    # let completions_path = ($nu.data-dir | path join "vendor/autoload/atuin-completions.nu")
    # lets not write the file every time, but check if it has changed
    # if (not ($completions_path | path exists) or (atuin gen-completions --shell nushell | decode utf-8) != (open $completions_path | decode utf-8)) {
    #    print $"updating ($completions_path)"
    #    atuin gen-completions --shell nushell | save -f $completions_path
    # }
}

# configure zoxide
if (which zoxide | is-not-empty) {
    update-autoload "zoxide.nu" { zoxide init nushell }

    # Alt/Option+L: interactive zoxide (fzf) directory query; insert the picked path at the cursor.
    $env.config.keybindings ++= [{
        name: zoxide_query_insert
        modifier: alt
        keycode: char_l
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            # NOTE: leading space keeps this out of atuin history (its `^ .+` history_filter).
            cmd: " let p = (do -i { zoxide query --interactive } | str trim); if not ($p | is-empty) { commandline edit --insert $p }"
        }
    }]
}

# configure pueue
if (which pueue | is-not-empty) {
    update-script generated_completions/ "pueue.nu" { pueue completions nushell }
}
