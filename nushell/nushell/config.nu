# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
#

# setup advanced completer for nushell
#

$env.CARAPACE_BRIDGES = 'zsh,fish'

let carapace_completer = {|spans|
  # if the current command is an alias, get it's expansion
  let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)

  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans | skip 1 | prepend ($spans.0)
  })

  carapace $spans.0 nushell ...$spans | from json
}

mkdir ($nu.data-dir | path join "vendor/autoload")

## configure starship prompt

if (which starship | is-not-empty) {
    let init_path = ($nu.data-dir | path join "vendor/autoload/starship.nu")
    # lets not write the file every time, but check if it has changed
    if (not ($init_path | path exists) or (starship init nu | decode utf-8) != (open $init_path | decode utf-8)) {
        print $"updating ($init_path)"
        starship init nu | save -f $init_path
    }

    # avoid same PROMPT_INDICATOR
    $env.PROMPT_INDICATOR = { "" }
    $env.PROMPT_INDICATOR_VI_INSERT = { ": " }
    $env.PROMPT_INDICATOR_VI_NORMAL = { "〉" }
    $env.PROMPT_MULTILINE_INDICATOR = { "::: " }
}

## configure atuin

if (which atuin | is-not-empty) {
    let init_path = ($nu.data-dir | path join "vendor/autoload/atuin.nu")
    # TODO(sgc): When atuin is updated, we'll re-enabled this, as I have modified the script
    #   to use the `--accept` flag to avoid prompting for confirmation
    # lets not write the file every time, but check if it has changed
    if false {
        if (not ($init_path | path exists) or (atuin init nu | decode utf-8) != (open $init_path | decode utf-8)) {
            print $"updating ($init_path)"
            atuin init nu | save -f $init_path
        }
    }

    # let completions_path = ($nu.data-dir | path join "vendor/autoload/atuin-completions.nu")
    # lets not write the file every time, but check if it has changed
    # if (not ($completions_path | path exists) or (atuin gen-completions --shell nushell | decode utf-8) != (open $completions_path | decode utf-8)) {
    #    print $"updating ($completions_path)"
    #    atuin gen-completions --shell nushell | save -f $completions_path
    # }
}

## configure zoxide

if (which zoxide | is-not-empty) {
    let init_path = ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
    # lets not write the file every time, but check if it has changed
    if (not ($init_path | path exists) or (zoxide init nushell | decode utf-8) != (open $init_path | decode utf-8)) {
        print $"updating ($init_path)"
        zoxide init nushell | save -f $init_path
    }
}

## configure pueue
if (which pueue | is-not-empty) {
    let init_path = ($nu.data-dir | path join "vendor/autoload/pueue.nu")
    # lets not write the file every time, but check if it has changed
    if (not ($init_path | path exists) or (pueue completions nushell | decode utf-8) != (open $init_path | decode utf-8)) {
        print $"updating ($init_path)"
        pueue completions nushell | save -f $init_path
    }
}

# some ls aliases

alias l  = ls
alias ll = ls -l
alias la = ls -al

## configure yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

$env.config.show_banner = false
$env.config.buffer_editor = "zed"
$env.config.completions.external = {
    enable: true,
    completer: $carapace_completer,
}

$env.EDITOR = "nvim"

# use homebrew sqlite3

use std/util "path add"
path add $"(brew --prefix sqlite3 | str trim | path join bin)"

source scripts/macos.nu

ulimit -n 10000
