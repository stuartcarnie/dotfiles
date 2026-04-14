def "nu-complete cmake-generators" [] {
    [
        "Unix Makefiles"
        "Ninja"
        "Ninja Multi-Config"
        "FASTBuild"
        "Watcom WMake"
        "Xcode"
    ]
}

def "nu-complete cmake-log-level" [] {
    ["ERROR", "WARNING", "NOTICE", "STATUS", "VERBOSE", "DEBUG", "TRACE"]
}

def "nu-complete cmake-trace-format" [] {
    ["human", "json-v1"]
}

def "nu-complete cmake-cache-vars" [] {
    ["build/CMakeCache.txt" "cmake-build*/CMakeCache.txt" "out/*/CMakeCache.txt"]
        | each { glob $in } | flatten
        | each {|f| open $f | lines }
        | flatten
        | where { $in !~ '^\s*(#|//)' and $in != "" }
        | where { $in !~ ':INTERNAL=' and $in !~ ':STATIC=' }
        | parse --regex '^(?<name>[A-Za-z_][A-Za-z0-9_]*):(?<type>[A-Z]+)=(?<val>.*)'
        | each {|e| { value: $"($e.name):($e.type)=", description: $e.val } }
}

def "nu-complete cmake-presets" [] {
    cmake --list-presets
        | lines
        | skip 1
        | where { $in starts-with "  " }
        | parse --regex '^\s+"(?<value>[^"]+)"\s+-\s+(?<description>.+)$'
}

def "nu-complete cmake-build-presets" [] {
    cmake --build --list-presets
        | lines
        | skip 1
        | where { $in starts-with "  " }
        | parse --regex '^\s+"(?<value>[^"]+)"\s+-\s+(?<description>.+)$'
}

# Cross-platform build system generator
export extern "cmake" [
    path?: path                                          # Source or build directory
    -S: path                                             # Explicitly specify a source directory
    -B: path                                             # Explicitly specify a build directory
    -C: path                                             # Pre-load a script to populate the cache
    -D: string@"nu-complete cmake-cache-vars"              # Create or update a cmake cache entry (<var>[:<type>]=<value>)
    -U: string                                           # Remove matching entries from CMake cache
    -G: string@"nu-complete cmake-generators"            # Specify a build system generator
    -T: string                                           # Specify toolset name if supported by generator
    -A: string                                           # Specify platform name if supported by generator
    --toolchain: path                                    # Specify toolchain file [CMAKE_TOOLCHAIN_FILE]
    --install-prefix: path                               # Specify install directory [CMAKE_INSTALL_PREFIX]
    --preset: string@"nu-complete cmake-presets"         # Specify a configure preset
    --list-presets                                       # List available presets
    -N                                                   # View mode only
    -P: path                                             # Process script mode
    --fresh                                              # Configure a fresh build tree, removing any existing cache file
    --graphviz: path                                     # Generate graphviz of dependencies
    --system-information                                 # Dump information about this system
    --print-config-dir                                   # Print CMake config directory
    --log-level: string@"nu-complete cmake-log-level"    # Set the verbosity of messages from CMake files
    --log-context                                        # Prepend log messages with context
    --debug-trycompile                                   # Do not delete the try_compile build tree
    --debug-output                                       # Put cmake in a debug mode
    --debug-find                                         # Put cmake find in a debug mode
    --debug-find-pkg: string                             # Limit cmake debug-find to comma-separated list of packages
    --debug-find-var: string                             # Limit cmake debug-find to comma-separated list of result variables
    --trace                                              # Put cmake in trace mode
    --trace-expand                                       # Put cmake in trace mode with variable expansion
    --trace-format: string@"nu-complete cmake-trace-format" # Set the output format of the trace
    --trace-source: path                                 # Trace only this CMake file/module
    --trace-redirect: path                               # Redirect trace output to a file instead of stderr
    --warn-uninitialized                                 # Warn about uninitialized values
    --no-warn-unused-cli                                 # Don't warn about command line options
    --check-system-vars                                  # Find problems with variable usage in system files
    --compile-no-warning-as-error                        # Ignore COMPILE_WARNING_AS_ERROR property and variable
    --link-no-warning-as-error                           # Ignore LINK_WARNING_AS_ERROR property and variable
    --profiling-format: string                           # Output data for profiling CMake scripts (google-trace)
    --profiling-output: path                             # Select an output path for profiling data
    --version                                            # Print version number and exit
    --help(-h)                                           # Print usage information and exit
    --help-full                                          # Print all help manuals and exit
    --help-manual: string                                # Print one help manual and exit
    --help-manual-list                                   # List help manuals available and exit
    --help-command: string                               # Print help for one command and exit
    --help-command-list                                  # List commands with help available and exit
    --help-module: string                                # Print help for one module and exit
    --help-module-list                                   # List modules with help available and exit
    --help-policy: string                                # Print help for one policy and exit
    --help-policy-list                                   # List policies with help available and exit
    --help-property: string                              # Print help for one property and exit
    --help-property-list                                 # List properties with help available and exit
    --help-variable: string                              # Print help for one variable and exit
    --help-variable-list                                 # List variables with help available and exit
]

# Build a CMake-generated project binary tree
export extern "cmake --build" [
    dir?: path                                           # Project binary directory to be built
    --preset: string@"nu-complete cmake-build-presets"   # Specify a build preset
    --list-presets                                       # List available build presets
    --parallel(-j): int                                  # Build in parallel using the given number of jobs
    --target(-t): string                                 # Build <tgt> instead of default targets
    --config: string                                     # For multi-configuration tools, choose configuration
    --clean-first                                        # Build target 'clean' first, then build
    --resolve-package-references: string                 # Restore/resolve package references during build (on|only|off)
    --verbose(-v)                                        # Enable verbose output
]

# Install a CMake-generated project binary tree
export extern "cmake --install" [
    dir: path                                            # Project binary directory to install
    --config: string                                     # For multi-configuration tools, choose configuration
    --component: string                                  # Component-based install, only install given component
    --default-directory-permissions: string               # Default install permission
    --parallel(-j): int                                  # Install in parallel using the given number of jobs
    --prefix: path                                       # The installation prefix CMAKE_INSTALL_PREFIX
    --strip                                              # Performing install/strip
    --verbose(-v)                                        # Enable verbose output
]
