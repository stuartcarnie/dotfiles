# xcodebuild uses single-dash long flags (-project, -scheme, …) that nushell's
# `extern` syntax cannot declare. We expose a single context-aware completer
# that inspects the previous token and returns the appropriate suggestions;
# flags themselves are typed as usual and passed straight through.

const BUILD_ACTIONS = [
    build, build-for-testing, analyze, archive,
    test, test-without-building,
    install-src, install, clean, docbuild
]

const DOWNLOAD_PLATFORMS = [ iOS, watchOS, tvOS, visionOS ]
const YES_NO = [ YES, NO ]

# Parses `xcodebuild -list -json` in the current directory, returning the
# top-level `project` / `workspace` record (or {} if no project is present).
def "xcb list-info" [] {
    let out = do -i { ^xcodebuild -list -json | complete }
    if ($out | is-empty) or $out.exit_code != 0 { return {} }
    let parsed = $out.stdout | from json
    $parsed.project? | default ($parsed.workspace? | default {})
}

def "xcb schemes" []        { xcb list-info | get -o schemes | default [] }
def "xcb targets" []        { xcb list-info | get -o targets | default [] }
def "xcb configurations" [] { xcb list-info | get -o configurations | default [] }

def "xcb sdks" [] {
    do -i { ^xcodebuild -showsdks -json | from json | get canonicalName } | default []
}

# Context-aware completer: looks at the token preceding the cursor to decide
# which list of suggestions is relevant. Falls back to build actions.
def "nu-complete xcodebuild" [context: string] {
    let tokens = $context | str trim --right | split row ' '
    let prev = $tokens | last

    match $prev {
        '-scheme'             => (xcb schemes),
        '-target'             => (xcb targets),
        '-configuration'      => (xcb configurations),
        '-sdk'                => (xcb sdks),
        '-downloadPlatform'   => $DOWNLOAD_PLATFORMS,
        '-enableCodeCoverage'
        | '-enableAddressSanitizer'
        | '-enableThreadSanitizer'
        | '-enableUndefinedBehaviorSanitizer'
        | '-parallel-testing-enabled'
        | '-test-timeouts-enabled'
        | '-test-repetition-relaunch-enabled' => $YES_NO,
        _ => $BUILD_ACTIONS,
    }
}

# Build Xcode projects, workspaces, and Swift packages
export extern "xcodebuild" [
    ...args: string@"nu-complete xcodebuild"
]
