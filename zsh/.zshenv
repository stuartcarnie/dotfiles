#
# Defines environment variables.
#

# MacOS workaround sneaky path_helper in /etc/zprofile
[ -x /usr/libexec/path_helper ] && eval `/usr/libexec/path_helper -s`

[ -f "${ZDOTDIR:-$HOME}/.zshenv.local" ] && source "${ZDOTDIR:-$HOME}/.zshenv.local"

export GOODPATH=$PATH
