#!/usr/bin/env nu

print "Configuring nushell..."

# configure all competions

if (which stow | is-empty) {
    print $"(ansi red_bold)ERROR:(ansi reset) stow not found"
    exit
}

# ^stow -t ($nu.data-dir | path join vendor autoload) -R completions/
# ^stow -t $nu.data-dir -R completions/
^stow -t $nu.data-dir -R nushell
mkdir ($nu.data-dir | path join vendor autoload)
