
" Get lines between markers or between previous marker and end of file and then copy to clipboard for Codewars.
function! <SID>copy_codewars()
    let marker = '^\(///\|###\|---\)'
    let curline = line('.')
    let lastline = line('$')

    let i = curline - 1
    let startrange = i
    while 1
        if match(getline(i), marker) >= 0
            let startrange = i + 2
            break
        endif
        if i <= 1
            let startrange = i
            break
        endif
        let i = i - 1
    endwhile

    let i = curline + 1
    let endrange = i
    while 1
        if match(getline(i), marker) >= 0
            let endrange = i - 2
            break
        endif
        if i >= lastline
            let endrange = i
            break
        endif
        let i = i + 1
    endwhile

    let cmd = startrange . ',' . endrange . 'yank +'
    execute cmd
endfunction
nnoremap <f12>[ :call <SID>copy_codewars()<cr>
