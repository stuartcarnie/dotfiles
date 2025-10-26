use std-rfc/kv *

export def find-project []: nothing -> string {
    let candidates = (glob *.xcodeproj)
    if ($candidates | length) == 1 {
        $candidates.0
    } else {
        null
    }
}

export def "project get-metadata" [
    name: string
]: nothing -> record<configurations: list<string>, name: string, schemes: list<string>, targets: list<string>, hash: string> {
    print "v2"
    let proj_file = ($name | path join "project.pbxproj" | path expand)
    let proj_hash = (open $proj_file | hash sha256)

    let existing = (kv get $"xcb::($proj_file)")
    if ($existing | is-empty) or ($existing.hash? != $proj_hash) {
        mut metadata = (xcodebuild -list -json | from json | $in.project)
        $metadata.hash = $proj_hash;
        kv set $"xcb::($proj_file)" $metadata
        $metadata
    } else {
        $existing
    }
}
