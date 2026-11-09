# Colours fade from their RGB value toward the background (Ghostty's default dark theme).
const BG = [40 44 52]
const FG = [220 223 228]

const LEVELS = {
    info: { icon: "\u{f05a}", color: [97 175 239] }
}

# Draw a toast in the top-right corner of the terminal that fades out (background job).
export def main [
    msg: string
    --level: string = "info" # one of: info
    --hold: duration = 1sec
] {
    let lvl = $LEVELS | get $level
    let bar = ('' | fill -c '─' -w (($"($lvl.icon) ($msg)" | str length -g) + 2))
    let lines = [$"╭($bar)╮" $"│ ($lvl.icon) ($msg) │" $"╰($bar)╯"]
    let size = term size
    let col = $size.columns - ($lines.0 | str length -g)
    # Prefer top-right; use bottom-right if the cursor is there, as erasing would blank the prompt.
    let cursor = try { term query (ansi cursor_position) --prefix (ansi csi) --terminator 'R' | decode | split row ';' | first | into int } catch { 0 }
    let top = if $cursor in 1..5 { $size.rows - 3 } else { 2 }
    let draw = {|text| $text | enumerate | each {|l| $"\e[($l.index + $top);($col)H($l.item)" } | str join }
    let rgb = {|c t| $c | zip $BG | each {|p| $p.0 + ($p.1 - $p.0) * $t | math round } | str join ';' }
    let frame = {|t|
        let fg = $"\e[38;2;(do $rgb $FG $t)m"
        let icon = $"\e[38;2;(do $rgb $lvl.color $t)m($lvl.icon)($fg)"
        print -n $"\e7($fg)(do $draw [$lines.0 $"│ ($icon) ($msg) │" $lines.2])\e[0m\e8"
    }
    job spawn {
        # Redraw while holding: reedline clears below the prompt on every repaint.
        let until = (date now) + $hold
        while (date now) < $until { do $frame 0; sleep 50ms }
        for i in 1..16 { do $frame ($i / 16); sleep 25ms }
        print -n $"\e7(do $draw ($lines | each {|l| '' | fill -w ($l | str length -g) }))\e8"
    } | ignore
}
