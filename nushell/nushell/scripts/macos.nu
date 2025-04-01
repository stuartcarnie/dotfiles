# Create a new RAM disk
def "ramdisk new" [
    name: string,   # Name of the RAM disk
    size: filesize  # Size of the RAM disk
]: nothing -> string {
    let sectors = ($size / 512 | into int)
    print $"Creating RAM disk '($name)' of ($size) / ($sectors) sectors..."

    let disk = (hdiutil attach -nomount ram://($sectors) | str trim)
    ^diskutil erasevolume HFS+ $"($name)" $disk
    $disk
}

alias lsregister = /System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister

# Fetch the contents of a URL and save it to a file
def "http download" [url] {
  let attachmentName  = (
    http head $url
    | transpose -dr
    | get -i content-disposition
    | parse "attachment; filename={filename}"
    | get filename?.0?
  )
  let filename = (
    if ($attachmentName | is-empty) {
      # use the end of the URL path
      ($url | url parse | get path | path parse | do {$"($in.stem).($in.extension)"})
    } else {
      $attachmentName
    }
  )
  http get --raw $url | save --progress $filename
}
