# env.nu
#
# Installed by:
# version = "0.101.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
#

$env.PATH = ([
    ($env.HOME | path join bin),
    ($env.HOME | path join go bin),
    ($env.HOME | path join .cargo bin),
    ($env.HOME | path join .krew bin),
] ++ (
    (/usr/libexec/path_helper -c) | str trim | lines | str substring 7.. | parse 'PATH "{value}";' | get value | get 0 | split row ':'
)) | uniq

# Add default directorys for additional modules
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join "modules")
    ($env.HOME | path join .local share nushell modules )
]
