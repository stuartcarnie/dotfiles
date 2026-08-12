# Commands that extend the brew command

# Show outdated brew packages
export def "outdated" []: nothing -> table {
    ^brew outdated --json
    | from json
    | items {|type, pkgs| $pkgs | insert type $type }
    | flatten
    | update installed_versions { str join ", " }
    | move type --before name
}
