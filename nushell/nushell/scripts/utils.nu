def "nu-complete widths" [] {
    [1,2,3,4,5]
}

#
export def "rpad" [
    width:int@"nu-complete widths" # Width
    character:string # character
]: [string -> string, int -> string] {
    fill --alignment r --width $width -c $character
}
