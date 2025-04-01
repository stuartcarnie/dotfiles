# Commands that extend the brew command

# Show outdated brew packages
export def "outdated" []: nothing -> table {
    ^brew outdated -v | detect columns --no-headers | reject column2 | rename package prev next
}
