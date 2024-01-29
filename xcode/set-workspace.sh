#!/bin/sh

# Only run the rest of the script if the file `workspace.xcconfig` exists
if [ ! -f workspace.xcconfig ]; then
  exit 0
fi

# Cut off the `$project.xcworkspace` part
workspacePath=`dirname $XcodeWorkspacePath`

cat <<EOF > workspace.xcconfig
CURRENT_WORKSPACE_FILE_PATH=$XcodeWorkspacePath
CURRENT_WORKSPACE_PATH=$workspacePath
