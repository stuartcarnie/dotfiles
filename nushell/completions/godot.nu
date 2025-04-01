# 2D and 3D cross-platform game engine
export extern "godot" [
    # General options
    --help(-h)                      # Display this help message.
    --version                       # Display the version string.
    --verbose(-v)                   # Use verbose stdout mode.
    --quiet                         # Quiet mode, silences stdout messages. Errors are still displayed.
    --no-header                     # Do not print engine version and rendering method header on startup.
    # Run options
    --editor(-e)                    # Start the editor instead of running the scene.
    --project-manager(-p)           # Start the project manager, even if a project is auto-detected.
    --recovery-mode                 # Start the editor in recovery mode, which disables features that can typically cause startup crashes, such as tool scripts, editor plugins, GDExtension addons, and others.
    --debug-server:string           # Start the editor debug server (<protocol>://<host/IP>[:port], e.g. tcp://
    --dap-port:int                  # Use the specified port for the GDScript Debugger Adaptor protocol. Recommended port range [1024, 49151].
    --lsp-port:int                  # Use the specified port for the GDScript language server protocol. Recommended port range [1024, 49151].
    --quit                          # Quit after the first iteration.
    --quit-after:int                # Quit after the given number of iterations. Set to 0 to disable.
    --language(-l):string           # Use a specific locale (<locale> being a two-letter code).
    --path:path                     # Path to a project (<directory> must contain a "project.godot" file).
    --upwards(-u)                   # Scan folders upwards for project.godot file.
    --main-pack:path                # Path to a pack (.pck) file to load.
    --render-thread:string@"nu-complete render-thread"  # Render thread mode ("unsafe" [deprecated], "safe", "separate").
    --remote-fs:string              # Remote filesystem (<host/IP>[:<port>] address).
    --remote-fs-password:string     # Password for remote filesystem.
    --audio-driver:string@"nu-complete audio-driver"    # Audio driver ["CoreAudio", "Dummy"].
    --display-driver:string@"nu-complete display-driver"  # Display driver (and rendering driver) ["macos" ("vulkan", "metal", "opengl3", "opengl3_angle"), "headless" ("dummy")].
    --audio-output-latency:int      # Override audio output latency in milliseconds (default is 15 ms).
    --rendering-method:string@"nu-complete rendering-method"  # Rendering method.
    --rendering-driver:string@"nu-complete rendering-driver"  # Rendering driver.
    --gpu-index:int                 # Use a specific GPU (run with --verbose to get a list of available devices).
    --text-driver:string            # Text driver (used for font rendering, bidirectional support and shaping).
    --tablet-driver:string          # Pen tablet input driver.
    --headless                      # Enable headless mode (--display-driver headless --audio-driver Dummy). Useful for servers and with --script.
    --log-file:path                 # Write output/error log to the specified path instead of the default location defined by the project.
    --write-movie:path              # Write a video to the specified path (usually with .avi or .png extension).
                                    # --fixed-fps is forced when enabled, but it can be used to change movie FPS.
                                    # --disable-vsync can speed up movie writing but makes interaction more difficult.
                                    # --quit-after can be used to specify the number of frames to write.
    # Display options
    --fullscreen(-f)                # Request fullscreen mode.
    --maximized(-m)                 # Request a maximized window.
    --windowed(-w)                  # Request windowed mode.
    --always-on-top(-t)             # Request an always-on-top window.
    --resolution:string             # Request window resolution (WxH).
    --position:string               # Request window position (X,Y).
    --screen:int                    # Request window screen.
    --single-window                 # Use a single window (no separate subwindows).
    --xr-mode:string                # Select XR (Extended Reality) mode ["default", "off", "on"].
    --wid:int                       # Request parented to window.
    # Debug options
    --debug(-d)                     # Debug (local stdout debugger).
    --breakpoints(-b):string        # Breakpoint list as source::line comma-separated pairs, no spaces (use %%20 instead).
    --profiling                     # Enable profiling in the script debugger.
    --gpu-profile                   # Show a GPU profile of the tasks that took the most time during frame rendering.
    --gpu-validation                # Enable graphics API validation layers for debugging.
    --gpu-abort                     # Abort on graphics API usage errors (usually validation layer errors). May help see the problem if your system freezes.
    --generate-spirv-debug-info     # Generate SPIR-V debug information. This allows source-level shader debugging with RenderDoc.
    --extra-gpu-memory-tracking     # Enables additional memory tracking (see class reference for `RenderingDevice.get_driver_and_device_memory_report()` and linked methods). Currently only implemented for Vulkan. Enabling this feature may cause crashes on some systems due to buggy drivers or bugs in the Vulkan Loader. See
    --accurate-breadcrumbs          # Force barriers between breadcrumbs. Useful for narrowing down a command causing GPU resets. Currently only implemented for Vulkan.
    --remote-debug:string           # Remote debug (<protocol>://<host/IP>[:<port>], e.g. tcp://
    --single-threaded-scene         # Force scene tree to run in single-threaded mode. Sub-thread groups are disabled and run on the main thread.
    --debug-collisions              # Show collision shapes when running the scene.
    --debug-paths                   # Show path lines when running the scene.
    --debug-navigation              # Show navigation polygons when running the scene.
    --debug-avoidance               # Show navigation avoidance debug visuals when running the scene.
    --debug-stringnames             # Print all StringName allocations to stdout when the engine quits.
    --debug-canvas-item-redraw      # Display a rectangle each time a canvas item requests a redraw (useful to troubleshoot low processor mode).
    --max-fps:int                   # Set a maximum number of frames per second rendered (can be used to limit power usage). A value of 0 results in unlimited framerate.
    --frame-delay:int               # Simulate high CPU load (delay each frame by <ms> milliseconds). Do not use as a FPS limiter; use --max-fps instead.
    --time-scale:float              # Force time scale (higher values are faster, 1.0 is normal speed).
    --disable-vsync                 # Forces disabling of vertical synchronization, even if enabled in the project settings. Does not override driver-level V-Sync enforcement.
    --disable-render-loop           # Disable render loop so rendering only occurs when called explicitly from script.
    --disable-crash-handler         # Disable crash handler when supported by the platform code.
    --fixed-fps:int                 # Force a fixed number of frames per second. This setting disables real-time synchronization.
    --delta-smoothing:string        # Enable or disable frame delta smoothing ["enable", "disable"].
    --print-fps                     # Print the frames per second to the stdout.
    --editor-pseudolocalization     # Enable pseudolocalization for the editor and the project manager.
    # Standalone tools
    --main-loop:string              # Run a MainLoop specified by its global class name.
    --benchmark                     # Benchmark the run time and print it to console.
    --benchmark-file:path           # Benchmark the run time and save it to a given file in JSON format. The path should
]

export extern "godot --script" [
    --check-only                    # Only parse for errors and quit.
]

export extern "godot --import" []

# Export the project in release mode using the given preset and output path. The preset name should match one defined in "export_presets.cfg".
# <path> should be absolute or relative to the project directory, and include the filename for the binary (e.g. "builds/game.exe").
export extern "godot --export-release" [
    preset:string
    path:path
]

def "nu-complete render-thread" [] {
    ['unsafe', 'safe', 'separate']
}

def "nu-complete audio-driver" [] {
    ['CoreAudio', 'Dummy']
}

def "nu-complete display-driver" [] {
    ['macos', 'headless']
}

def "nu-complete rendering-driver" [] {
    ['metal', 'vulkan', 'opengl3', 'dummy']
}

def "nu-complete rendering-method" [] {
    ['forward_plus', 'mobile', 'gl_compatibility']
}

# Standalone tools:
#   --export-debug <preset> <path>    E  Export the project in debug mode using the given preset and output path. See --export-release description for other considerations.
#   --export-pack <preset> <path>     E  Export the project data only using the given preset and output path. The <path> extension determines whether it will be in PCK or ZIP format.
#   --export-patch <preset> <path>    E  Export pack with changed files only. See --export-pack description for other considerations.
#   --patches <paths>                 E  List of patches to use with --export-patch. The list is comma-separated.
#   --install-android-build-template  E  Install the Android build template. Used in conjunction with --export-release or --export-debug.
#   --convert-3to4
#     [max_file_kb] [max_line_size]   E  Converts project from Godot 3.x to Godot 4.x.
#   --validate-conversion-3to4
#     [max_file_kb] [max_line_size]   E  Shows what elements will be renamed when converting project from Godot 3.x to Godot 4.x.
#   --doctool [path]                  E  Dump the engine API reference to the given <path> (defaults to current directory) in XML format, merging if existing files are found.
#   --no-docbase                      E  Disallow dumping the base types (used with --doctool).
#   --gdextension-docs                E  Rather than dumping the engine API, generate API reference from all the GDExtensions loaded in the current project (used with --doctool).
#   --gdscript-docs <path>            E  Rather than dumping the engine API, generate API reference from the inline documentation in the GDScript files found in <path> (used with --doctool).
#   --build-solutions                 E  Build the scripting solutions (e.g. for C# projects). Implies --editor and requires a valid project to edit.
#   --dump-gdextension-interface      E  Generate a GDExtension header file "gdextension_interface.h" in the current folder. This file is the base file required to implement a GDExtension.
#   --dump-extension-api              E  Generate a JSON dump of the Godot API for GDExtension bindings named "extension_api.json" in the current folder.
#   --dump-extension-api-with-docs    E  Generate JSON dump of the Godot API like the previous option, but including documentation.
#   --validate-extension-api <path>   E  Validate an extension API file dumped (with one of the two previous options) from a previous version of the engine to ensure API compatibility.
#                                        If incompatibilities or errors are detected, the exit code will be non-zero.
#   --benchmark                       E  Benchmark the run time and print it to console.
#   --benchmark-file <path>           E  Benchmark the run time and save it to a given file in JSON format. The path should be absolute.
