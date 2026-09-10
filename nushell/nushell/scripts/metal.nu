# Display man pages for the installed Metal toolchain
@category "metal"
@search-terms metal man help
def metal-man [page: string] {
  let mandir = (xcrun -sdk macosx --find metal-tt | str trim | path dirname | path dirname | path join share man)
  man -M $mandir $page
}
