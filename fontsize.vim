vim9script

const MINFONTSIZE = 8
const MAXFONTSIZE = 36
const ORIGFONTSTR = '0xProto Nerd Font 18,CommitMono Nerd Font Mono 18,DejaVu Sans Mono 18,7x14bold'

def GetFontSize(): number
    var freq = {}
    for font in split(&guifont, ',')
        var m = matchlist(font, '\s\+\(\d\+\)$')
        if m != []
            var sz = m[1]
            if !has_key(freq, sz)
                freq[sz] = 0
            endif
            freq[sz] += 1
            echo freq
        endif
    endfor
    var top = max(freq)
    for [k, v] in items(freq)
        if v == top
            return str2nr(k)
        endif
    endfor
    throw 'Cannot determine current font size'
enddef

def ChangeFontSize(oldsize: number, newsize: number)
    var results = []
    for font in split(&guifont, ',')
        add(results, substitute(font, '\(\s\)' .. oldsize .. '$', '\1' .. newsize, ''))
    endfor
    &guifont = join(results, ',')
    redraw
    echo 'Font size set to ' .. newsize
enddef

def IncrFontSize(incr: number)
    var oldsize = GetFontSize()
    var newsize = min([max([oldsize + incr, MINFONTSIZE]), MAXFONTSIZE])
    ChangeFontSize(oldsize, newsize)
enddef

def ResetFontSize()
    &guifont = ORIGFONTSTR
enddef

nnoremap <C-a> <ScriptCmd>ResetFontSize()<cr>
nnoremap <C-b> <ScriptCmd>IncrFontSize(1)<cr>
nnoremap <C-c> <ScriptCmd>IncrFontSize(-1)<cr>
