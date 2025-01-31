vim9script

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

nnoremap <f3> <ScriptCmd>echo GetFontSize()<cr>
