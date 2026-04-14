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

def update-autoload [name: string, generator: closure] {
    let init_path = ($nu.data-dir | path join $"vendor/autoload/($name)")
    let content = (do $generator | decode utf-8)
    if (not ($init_path | path exists) or $content != (open $init_path | decode utf-8)) {
        print $"updating ($init_path)"
        $content | save -f $init_path
    }
}

## configure starship prompt

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

## configure zoxide

if (which zoxide | is-not-empty) {
    update-autoload "zoxide.nu" { zoxide init nushell }
}

## configure pueue
if (which pueue | is-not-empty) {
    update-autoload "pueue.nu" { pueue completions nushell }
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
$env.config.use_kitty_protocol = true
$env.config.completions.algorithm = "fuzzy"

$env.config.history = {
  file_format: sqlite
  max_size: 5_000_000
  sync_on_enter: true
  isolation: true
}

$env.config.hinter = {
  closure: {|ctx|
    if ($ctx.line | str length) == 0 {
      null
    } else {
      mut candidate = (try {
        ^atuin search --filter-mode directory --limit 1 --search-mode prefix --cmd-only $ctx.line
        | lines
        | first
      } catch {
        null
      })

      if $candidate == null or not ($candidate | str starts-with $ctx.line) {
        $candidate = (try {
            ^atuin search --filter-mode session --limit 1 --search-mode prefix --cmd-only $ctx.line
            | lines
            | first
        } catch {
            null
        })
      }

      if $candidate == null or not ($candidate | str starts-with $ctx.line) {
        $candidate = (try {
            ^atuin search --filter-mode global --limit 1 --search-mode prefix --cmd-only $ctx.line
            | lines
            | first
        } catch {
            null
        })
      }

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

use std/util "path add"
path add $"(brew --prefix sqlite3 | str trim | path join bin)"

source scripts/macos.nu

ulimit -n 10000

# Configure nu_plugin_skim
# See: https://github.com/idanarye/nu_plugin_skim/tree/main
$env.SKIM_DEFAULT_OPTIONS = "--bind ctrl-o:preview-page-up,ctrl-p:preview-page-down,ctrl-t:toggle-preview"

# use `/Users/stuartcarnie/Library/Application Support/org.dystroy.broot/launcher/nushell/br` *
