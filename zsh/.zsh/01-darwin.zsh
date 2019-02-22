[[ "$(uname 2> /dev/null)" == "Darwin" ]] && {
	# only for macOS
	
	# ensure system python is used for swift and lldb to eliminate errors
	alias lldb='PATH="/usr/bin:$PATH" lldb'
	alias swift='PATH="/usr/bin:$PATH" swift'
}