# Completions for `mc`, the MinIO Client.

# Configured aliases, e.g. `play/`.
def "nu-complete mc aliases" [] {
    ^mc alias ls --json
    | complete
    | if $in.exit_code == 0 { $in.stdout } else { "" }
    | lines
    | each { from json }
    | where status == "success"
    | each {|it| { value: $"($it.alias)/", description: $it.URL } }
}

# List one level below the last `/` in $token, so nushell can prefix-filter the
# remainder. `folders_only` restricts results to buckets/prefixes.
def "nu-complete mc list" [token: string, folders_only: bool] {
    if not ($token | str contains '/') {
        return (nu-complete mc aliases)
    }

    let base = ($token | split row '/' | drop 1 | str join '/') + '/'

    ^mc ls $base --json
    | complete
    | if $in.exit_code == 0 { $in.stdout } else { "" }
    | lines
    | each { from json }
    | where status == "success"
    | where { not $folders_only or $in.type == "folder" }
    | each {|it| {
        value: $"($base)($it.key)"
        description: (if $it.type == "folder" { "" } else { $it.size | into filesize | to text })
    } }
}

def "nu-complete mc path" [context: string] {
    { options: { sort: false }, completions: (nu-complete mc list ($context | split row ' ' | last) false) }
}

def "nu-complete mc bucket" [context: string] {
    { options: { sort: false }, completions: (nu-complete mc list ($context | split row ' ' | last) true) }
}

# List buckets and objects
export extern "mc ls" [
    ...target: string@"nu-complete mc path"
    --rewind: string        # list all object versions no later than specified date
    --versions              # list all versions
    --recursive(-r)         # list recursively
    --incomplete(-I)        # list incomplete uploads
    --summarize             # display summary information (number of objects, total size)
    --storage-class: string # filter to specified storage class
    --zip                   # list files inside zip archive (MinIO servers only)
    --config-dir(-C): path  # path to configuration folder
    --quiet(-q)             # disable progress bar display
    --disable-pager         # disable mc internal pager and print to raw stdout
    --no-color              # disable color theme
    --json                  # enable JSON lines formatted output
    --debug                 # enable debug output
    --insecure              # disable SSL certificate verification
    --custom-header(-H): string # add custom HTTP header to the request, 'key:value' format
    --help(-h)              # show help
]

# Display object contents
export extern "mc cat" [
    ...target: string@"nu-complete mc path"
    --rewind: string        # display an earlier object version
    --version-id: string    # display a specific version of an object
    --zip                   # extract from remote zip file (MinIO server source only)
    --offset: int           # start offset
    --tail: int             # tail number of bytes at ending of file
    --part-number: int      # download only a specific part number
    --enc-c: string         # decrypt objects using client provided keys
    --config-dir(-C): path  # path to configuration folder
    --quiet(-q)             # disable progress bar display
    --disable-pager         # disable mc internal pager and print to raw stdout
    --no-color              # disable color theme
    --json                  # enable JSON lines formatted output
    --debug                 # enable debug output
    --insecure              # disable SSL certificate verification
    --custom-header(-H): string # add custom HTTP header to the request, 'key:value' format
    --help(-h)              # show help
]

# Remove a bucket
export extern "mc rb" [
    ...target: string@"nu-complete mc bucket"
    --force                 # force a recursive remove operation on all object versions
    --dangerous             # allow site-wide removal of objects
    --config-dir(-C): path  # path to configuration folder
    --quiet(-q)             # disable progress bar display
    --disable-pager         # disable mc internal pager and print to raw stdout
    --no-color              # disable color theme
    --json                  # enable JSON lines formatted output
    --debug                 # enable debug output
    --insecure              # disable SSL certificate verification
    --custom-header(-H): string # add custom HTTP header to the request, 'key:value' format
    --help(-h)              # show help
]
