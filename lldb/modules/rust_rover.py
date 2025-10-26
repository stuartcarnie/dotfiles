import lldb
import os

bundle_id = os.getenv("__CFBundleIdentifier")
if bundle_id == "com.jetbrains.rustrover":
    print("🦀 Found RustRover")

    # Your configuration code
    debugger = lldb.debugger
    debugger.HandleCommand("process handle SIGINT -n true -p true -s false")

    print("⚠️ Disabled SIGINT handling, so you can send SIGINT to the process to stop it")

    lldb.debugger.HandleCommand('command script add -f on_target_created target_setup')

def on_target_created(debugger, command, result, internal_dict):
    print("Target started")
