# Commands that extend the brew command

# Show outdated brew packages
export def "outdated" []: nothing -> table {
    ^brew outdated -v | parse --regex '^(?<name>\S+) \((?<current>\S+)\) < (?<latest>\S+)(?: \[pinned at (?<pinned>\S+)\])?$'
}
