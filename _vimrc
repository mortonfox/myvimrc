version 7.0

" ----- General Options ----- {{{1

" Set the character encoding used inside Vim.
" This option has to come before autochdir in order to not trigger
" a bug with relative pathnames on Vim startup.
set encoding=utf-8
" Do not automatically change directories.
" silent! is needed because this option is not available unless certain
" features have been enabled.
silent! set noautochdir

if has("autocmd")
    augroup cmdt_auto
	" Clear all auto-commands.
	autocmd!
	" Use clipboard register, if available.
	autocmd VimEnter * call <SID>set_clipboard()
    augroup END
endif

" copy indent when starting a new line
set autoindent
" autosave before major commands
set autowrite
" dark background
set background=dark
" allow backspacing over newlines and past start of insert
set backspace=2
" don't leave backup files
set nobackup

" If the clipboard register is available, use it for all yank, delete,
" change and put operations.
function! s:got_clipboard()
    if !has('clipboard')
	return 0
    endif
    let save_clip = @*
    let @* = 'xx'
    let retval = @* == 'xx'
    let @* = save_clip
    return retval
endfunction

function! <SID>set_clipboard()
    " echom "Got clipboard = ".s:got_clipboard()
    set clipboard-=unnamed
    if s:got_clipboard()
	set clipboard+=unnamed
    endif
endfunction

" be iMproved
set nocompatible

" :write command with a file name sets alternate file name for the current
" window.
" :write command with a file name sets name of buffer if the buffer does not
" have a name.
" set buffer options when first entering a buffer
set cpoptions=AFs
" Display as much of the last line as possible.
set display=lastline
" Do not equalize window heights after closing a window.
set noequalalways
" Detect these fileformats.
set fileformats=unix,dos
" g is on by default for search and replace
set gdefault
" GUI cursor options
" In visual mode, the cursor needs to be a little different from the
" selection color for visibility.
set guicursor=n-c:block-Cursor-blinkon0
set guicursor+=v:block-vCursor-blinkon0
set guicursor+=o:hor50-Cursor-blinkon0
set guicursor+=i-ci:ver25-Cursor-blinkon0
set guicursor+=r-cr:hor20-Cursor-blinkon0
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
" gui options: disable menus, toolbar, scrollbars
set guioptions-=m
set guioptions-=a
set guioptions+=a
set guioptions-=T
set guioptions-=r
set guioptions-=l
" hide current buffer when switching to a new file
set hidden
" increase amount of command line history kept
set history=50
" ignore case in searches
set ignorecase
" incremental search
set incsearch
" infer case of completed portion in keyword completion
set infercase
" don't insert two spaces after a period with the join command
set nojoinspaces
" last window always has status line
set laststatus=2
" do not redraw while executing macros
set lazyredraw
" magic search patterns
set magic
" hide the mouse pointer while typing characters
set mousehide
" Support Ctrl-A and Ctrl-X for letters and hex numbers, not octal
set nrformats=alpha,hex
" Set paper size
set printoptions=paper:letter
" show line/column of cursor position
set ruler
" keep at least 5 lines above and below the cursor
set scrolloff=5
" round indent to multiple of shiftwidth
set shiftround
" number of spaces for ^T/^D
set shiftwidth=4
" shorten file messages
set shortmess=atIA
" show command in status line
set showcmd
" show matching bracket
set showmatch
" Truncate long messages.
set shortmess+=T
" override ignorecase if search pattern contains upper case characters
set smartcase
" Customize status line
if version >= 700
    set statusline=%f%#User1#
else
    set statusline=%f%1*
endif
set statusline+=\ [%M%R%W]\ [%{&fileformat}]%y\ B%n%a
set statusline+=\ %=L%l/%L\ C%-4(%c%V/%{strlen(getline('.'))}%)\ %3p%%
" match .err (Watcom C++ errors) files last
" match graphics files and executables last
set suffixes-=.err,.gif,.jpg,.png,.exe,.dll
set suffixes+=.err,.gif,.jpg,.png,.exe,.dll
" mode for fast tty
set ttyfast
" allow cursor to wrap across line boundaries for all commands
set whichwrap=b,s,h,l,<,>,[,]
" Show command line completion menu.
set wildmenu

" ----- Initialization ----- {{{1
" clear all mappings
nmapclear
vmapclear
omapclear
imapclear
cmapclear

" runtime bundle/vim-pathogen/autoload/pathogen.vim
" silent! execute pathogen#infect()

" ===== Load Vundle ===== {{{2
filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:

" original repos on GitHub
Bundle 'godlygeek/tabular'
Bundle 'jnwhiteh/vim-golang'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'mortonfox/vim-commentary'
Bundle 'nicoraffo/conque'
Bundle 'rking/ag.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'    
Bundle 'tek/vim-quickbuf'
Bundle 'vimoutliner/vimoutliner'

" vim-scripts repos
Bundle 'Align'
Bundle 'IndentAnything'
Bundle 'javacomplete'
Bundle 'Javascript-Indentation'
" Bundle 'QuickBuf'

" ===== Other Initialization ===== {{{2

" Make filetype.vim treat .h files as C files.
" let c_syntax_for_h=1

filetype plugin indent on
" runtime! ftdetect/*.vim

" Shift-F4 brings up QuickBuf.
" let g:qb_hotkey = '<S-F4>'
let g:quickbuf_map = '<S-F4>'

" ----- GUI customization ----- {{{1

" In vim 5.4 with GTK+, the .font resource does not work.
if has("gui_gtk") && has("gui_running")
    set guifont=DejaVu\ Sans\ Mono\ 10,7x14bold
endif

if (has('win32') || has('win64')) && has('gui_running')
    " Disable middle mouse paste in win32 GUI. That is very annoying with a
    " wheel mouse.
    noremap <MiddleMouse> <Nop>
    lnoremap <MiddleMouse> <Nop>
    noremap <2-MiddleMouse> <Nop>
    lnoremap <2-MiddleMouse> <Nop>
    noremap <3-MiddleMouse> <Nop>
    lnoremap <3-MiddleMouse> <Nop>
    noremap <4-MiddleMouse> <Nop>
    lnoremap <4-MiddleMouse> <Nop>

    " Special font for the Windows GUI.
    set guifont=Fixedsys:h9
endif

" Special font for the Mac
if has("mac") && has("gui_running")
    set guifont=monaco:h14
endif


" If the gvim window is too small, try setting it larger.
if &lines < 40 && has("gui_running")
    set lines=40
endif

" ----- Hotkey Customization ----- {{{1

" map F2 key to save file in insert and command modes
nnoremap <F2> :write<CR>
vnoremap <F2> <esc>:write<CR>
inoremap <F2> <C-O>:write<CR>

" Map F6 key to go to the next buffer and Shift-F6 to go to the previous
" buffer.
nnoremap <F6> :bnext<CR>
vnoremap <F6> <esc>:bnext<CR>
inoremap <F6> <C-O>:bnext<CR>
nnoremap <S-F6> :bprevious<CR>
vnoremap <S-F6> <esc>:bprevious<CR>
inoremap <S-F6> <C-O>:bprevious<CR>

" F7 will toggle NERDTree.
nnoremap <silent> <F7> :NERDTreeToggle<cr>
vnoremap <silent> <F7> <esc>:NERDTreeToggle<cr>
inoremap <silent> <F7> <C-O>:NERDTreeToggle<cr>

" F9 will toggle taglist.
nnoremap <silent> <F9> :TlistToggle<cr>
vnoremap <silent> <F9> <esc>:TlistToggle<cr>
inoremap <silent> <F9> <C-O>:TlistToggle<cr>

let Tlist_Process_File_Always = 1
let Tlist_Use_Right_Window = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Show_Menu = 1

" shift-insert will now paste text from clipboard
nnoremap <S-Insert> "*P
vnoremap <S-Insert> "-d"*P
noremap! <S-Insert> <C-R><C-R>*
vnoremap <C-Insert> "*y
vnoremap <S-Delete> "*d
vnoremap <C-Delete> "*d

" ctrl-tab, ctrl-shift-tab moves between tabs
nnoremap <C-Tab> gt
vnoremap <C-Tab> <esc>gt
noremap! <C-Tab> <esc>gt
nnoremap <C-S-Tab> gT
vnoremap <C-S-Tab> <esc>gT
noremap! <C-S-Tab> <esc>gT

" F12 p runs par on the current paragraph or visual range
" F12 P does the same thing but waits for user to type in arguments.
nnoremap <F12>p {!}par<cr>
inoremap <F12>p <esc>{!}par<cr>
vnoremap <F12>p !par<cr>
nnoremap <F12>P {!}par<space>
inoremap <F12>P <esc>{!}par<space>
vnoremap <F12>P !par<space>

" F12 a runs tal on the current paragraph or visual range.
" F12 A does the same thing but waits for user to type in arguments.
nnoremap <F12>a {!}tal<cr>
inoremap <F12>a <esc>{!}tal<cr>
vnoremap <F12>a !tal<cr>
nnoremap <F12>A {!}tal<space>
inoremap <F12>A <esc>{!}tal<space>
vnoremap <F12>A !tal<space>

" F12 b runs boxes on the current paragraph or visual range.
" F12 B does the same thing but waits for user to type in arguments.
nnoremap <F12>b {!}boxes<cr>
inoremap <F12>b <esc>{!}boxes<cr>
vnoremap <F12>b !boxes<cr>
nnoremap <F12>B {!}boxes<space>
inoremap <F12>B <esc>{!}boxes<space>
vnoremap <F12>B !boxes<space>

" F12 x runs boxes -r on the current paragraph or visual range.
" F12 X does the same thing but waits for user to type in arguments.
nnoremap <F12>x {!}boxes -r<cr>
inoremap <F12>x <esc>{!}boxes -r<cr>
vnoremap <F12>x !boxes -r<cr>
nnoremap <F12>X {!}boxes -r<space>
inoremap <F12>X <esc>{!}boxes -r<space>
vnoremap <F12>X !boxes -r<space>

" F12 ve edits .vimrc file
" F12 vs sources .vimrc file
nnoremap <F12>ve :edit $MYVIMRC<cr>
vnoremap <F12>ve <esc>:edit $MYVIMRC<cr>
inoremap <F12>ve <esc>:edit $MYVIMRC<cr>
nnoremap <F12>vs :source $MYVIMRC<cr>
vnoremap <F12>vs <esc>:source $MYVIMRC<cr>
inoremap <F12>vs <esc>:source $MYVIMRC<cr>

" F11: directory change commands

" F11 h: startup directory (home)
let s:startdir=getcwd()
function! <SID>GetStartDir()
    return s:startdir
endfunction
nnoremap <F11>h :execute "cd" '<c-r>=<SID>GetStartDir()<cr>'<cr>:pwd<cr>
vnoremap <F11>h <esc>:execute "cd" '<c-r>=<SID>GetStartDir()<cr>'<cr>:pwd<cr>
inoremap <F11>h <esc>:execute "cd" '<c-r>=<SID>GetStartDir()<cr>'<cr>:pwd<cr>

" F11 c: change current directory to the directory in which the current
" file resides.
nnoremap <F11>c :cd <C-R>=expand("%:p:h")<cr><cr>
vnoremap <F11>c <esc>:cd <C-R>=expand("%:p:h")<cr><cr>
inoremap <F11>c <esc>:cd <C-R>=expand("%:p:h")<cr><cr>

" F12 e: edit another file in the same directory as the current file.
nnoremap <F12>e :e <C-R>=expand("%:p:h")."/"<cr>
vnoremap <F12>e <esc>:e <C-R>=expand("%:p:h")."/"<cr>
inoremap <F12>e <esc>:e <C-R>=expand("%:p:h")."/"<cr>

" F4 toggles list mode
nnoremap <F4> :set invlist list?<cr>
vnoremap <F4> <esc>:set invlist list?<cr>
inoremap <F4> <C-o>:set invlist list?<cr>

" F5 toggles paste mode
nnoremap <F5> :set invpaste paste?<CR>
vnoremap <F5> <esc>:set invpaste paste?<CR>
" pastetoggle key in vim 5.4 allows us to get out of paste mode
" even from within insert mode.
inoremap <F5> <C-O>:set invpaste<CR>
set pastetoggle=<F5>

" iTerm2 sends nul characters for anti-idle. Ignore those characters in
" text mode.
if has("mac") && !has("gui_running")
    inoremap <C-@> <Nop>
    cnoremap <C-@> <Nop>
    lnoremap <C-@> <Nop>
endif


" ----- Vim Scripts ----- {{{1

" ===== Toggle syntax ===== {{{2

" Initialize all highlights that have nothing to do with syntax.
function! s:Highlight_Init()
    highlight vCursor guifg=bg guibg=DarkGrey
    highlight StatusLine gui=bold guifg=yellow guibg=#505050
    highlight StatusLineNC gui=NONE guifg=yellow guibg=#505050
    highlight User1 term=inverse cterm=inverse 
    highlight User1 gui=NONE guifg=green guibg=#505050
	
    " Use some special X11 colors.
    if has("x11") && has("gui_running")
	let backgr="MidnightBlue"
	let s:commentfg="gold"
    else
	let backgr="black"
	let s:commentfg="orange"
    endif

    " color customizations
    highlight Normal guifg=Gray ctermfg=Gray
    highlight MoreMsg guifg=LightGreen ctermfg=LightGreen
    highlight Question guifg=LightGreen ctermfg=LightGreen
    highlight Directory guifg=LightBlue ctermfg=Cyan
    highlight NonText guifg=Yellow ctermfg=Yellow
    highlight Visual gui=reverse guifg=grey guibg=bg
    highlight SpecialKey guifg=Magenta

    execute "highlight Normal guibg=" . backgr "ctermbg=black"
    execute "highlight MoreMsg guibg=" . backgr "ctermbg=black"
    execute "highlight Question guibg=" . backgr "ctermbg=black"
    execute "highlight NonText guibg=" . backgr "ctermbg=black"
    execute "highlight ModeMsg guibg=" . backgr "ctermbg=black"

    if version >= 700
	highlight MatchParen guifg=Yellow ctermfg=Yellow guibg=Blue ctermbg=Blue
	highlight PMenu guifg=Gray guibg=#513692
	highlight PMenuSel guifg=Gray guibg=#824C21
	highlight PMenuSbar guifg=Gray guibg=#824C21
	highlight PMenuThumb guifg=Gray guibg=#824C21
    endif

    " Customize folding colors.
    highlight Folded guifg=LightCyan guibg=bg
    highlight FoldColumn guifg=LightCyan guibg=bg
    highlight Folded ctermfg=LightCyan ctermbg=bg
    highlight FoldColumn ctermfg=LightCyan ctermbg=bg
endfunction

" The syntax on command resets all custom syntax highlights. So we
" define a function to turn the syntax highlighting on and restore the
" custom highlights.
function! s:Turn_syntax_on()
    unlet! g:colors_name
    syntax on

    " Set colors_name so MacVim's default colorscheme doesn't override our
    " colors.
    let g:colors_name='vimrc'

    execute "highlight Comment guifg=". s:commentfg "ctermfg=Yellow"
    highlight PreProc guifg=Magenta ctermfg=LightMagenta
    highlight Statement guifg=LightGreen ctermfg=LightGreen gui=NONE
    highlight Delimiter guifg=Yellow ctermfg=Yellow
    highlight Special guifg=Red ctermfg=LightRed
    highlight Type guifg=Cyan ctermfg=Cyan gui=NONE
    highlight Identifier guifg=LightCyan ctermfg=LightCyan
    if has('mac')
	highlight Identifier guifg=Cyan ctermfg=LightCyan
    endif

    " Set the html_my_rendering variable so that html.vim won't clobber
    " our html highlight settings.
    let g:html_my_rendering=1
    
    highlight htmlLink term=underline 
    highlight htmlLink cterm=underline ctermfg=yellow
    highlight htmlLink gui=underline guifg=yellow

    highlight htmlBold term=bold cterm=bold gui=bold
    
    highlight htmlBoldUnderline term=bold,underline 
    highlight htmlBoldUnderline cterm=bold,underline ctermfg=yellow
    highlight htmlBoldUnderline gui=bold,underline guifg=yellow
    
    highlight htmlBoldItalic term=bold 
    highlight htmlBoldItalic cterm=bold,italic ctermfg=lightgreen
    highlight htmlBoldItalic gui=bold guifg=lightgreen
    
    highlight htmlBoldUnderlineItalic term=bold,underline 
    highlight htmlBoldUnderlineItalic cterm=bold,underline 
    highlight htmlBoldUnderlineItalic ctermfg=lightgreen 
    highlight htmlBoldUnderlineItalic gui=bold,underline guifg=lightgreen
    
    highlight htmlUnderline term=underline cterm=underline gui=underline
    
    highlight htmlUnderlineItalic term=underline
    highlight htmlUnderlineItalic cterm=underline ctermfg=lightgreen
    highlight htmlUnderlineItalic gui=underline guifg=lightgreen

    highlight htmlItalic term=NONE 
    highlight htmlItalic cterm=NONE ctermfg=lightgreen 
    highlight htmlItalic gui=NONE guifg=lightgreen
endfunction

function! <SID>Toggle_syntax()
    if has("syntax_items")
	syntax off
    else
	call s:Highlight_Init()
	call s:Turn_syntax_on()
    endif
endfunction

" Ctrl-F7 toggles syntax coloring on and off
nnoremap <C-F7> :call <SID>Toggle_syntax()<cr>
vnoremap <C-F7> <esc>:call <SID>Toggle_syntax()<cr>
inoremap <C-F7> <esc>:call <SID>Toggle_syntax()<cr>

" Also define a :ToggleSyntax command.
command! ToggleSyntax :call <SID>Toggle_syntax()

" Shift-F7 will show syntax item at cursor
nnoremap <S-F7> :echo synIDattr(synID(line("."), col("."), 1), "name")<CR>
vnoremap <S-F7> <esc>:echo synIDattr(synID(line("."), col("."), 1), "name")<CR>
inoremap <S-F7> <esc>:echo synIDattr(synID(line("."), col("."), 1), "name")<CR>

" Start with syntax highlighting enabled.
call s:Highlight_Init()
call s:Turn_syntax_on()

" ===== Maximize/unmaximize vertically. ===== {{{2
function! <SID>Toggle_full_height()
    if exists("s:orig_height")
	execute 'set lines=' . s:orig_height
	unlet s:orig_height
    else
	let s:orig_height=&lines
	set lines=999
    endif
endfunction

" Ctrl-F9 toggles full height mode
nnoremap <C-F9> :call <SID>Toggle_full_height()<cr>
vnoremap <C-F9> <esc>:call <SID>Toggle_full_height()<cr>
inoremap <C-F9> <esc>:call <SID>Toggle_full_height()<cr>

" Also define a :FullHeight command.
command! FullHeight :call <SID>Toggle_full_height()

" ===== Remove all buffers. ===== {{{2
function! <SID>Del_all_buf()
    let bufidx = 1
    while bufidx <= bufnr("$")
	if bufloaded(bufidx)
	    execute 'bd' bufidx
	endif
	let bufidx = bufidx + 1
    endw
endfunction

" F12 d removes all buffers.
nnoremap <F12>d :call <SID>Del_all_buf()<cr>
vnoremap <F12>d <esc>:call <SID>Del_all_buf()<cr>
inoremap <F12>d <esc>:call <SID>Del_all_buf()<cr>

" ===== Commentify ===== {{{2
" A function that commentifies or uncommentifies a line. (for C
" programs)
function! <SID>Commentify_c()
    if getline(".") =~ '^\s*/\* ' && getline(".") =~ ' \*/\s*$'
	normal ^3x$xxx
    else
	execute "normal ^i/* \<esc>A */\<esc>"
    endif
endfunction

" A function that commentifies or uncommentifies a line. (for Java
" programs)
function! <SID>Commentify_java()
    if getline(".") =~ '^\s*// ' 
	normal ^3x
    else
	execute "normal ^i// \<esc>"
    endif
endfunction

" A function that commentifies or uncommentifies a line. (for Perl
" scripts)
function! <SID>Commentify_perl()
    if getline(".") =~ '^# '
	call setline('.', strpart(getline('.'), 2))
    else
	call setline('.', '# '.getline('.'))
    endif
endfunction

" A function that commentifies or uncommentifies a line. (for vim
" scripts)
function! <SID>Commentify_vim()
    if getline(".") =~ '^" '
	call setline('.', strpart(getline('.'), 2))
    else
	call setline('.', '" '.getline('.'))
    endif
endfunction

" A function that commentifies or uncommentifies a line. (for TeX)
function! <SID>Commentify_tex()
    if getline(".") =~ '^% '
	normal 0xx
    else
	execute "normal 0i% \<esc>"
    endif
endfunction

" A function that commentifies or uncommentifies a line. (for Lua)
function! <SID>Commentify_lua()
    if getline(".") =~ '^-- '
	normal 0xxx
    else
	execute "normal 0i-- \<esc>"
    endif
endfunction

" A function that commentifies or uncommentifies a line. It adapts to
" the source code using the current vim syntax.
function! <SID>Commentify()
    " The current_syntax variable may not exist in a new buffer.
    if (exists("b:current_syntax"))
	if b:current_syntax == "c" || b:current_syntax == "cpp"
	    call <SID>Commentify_c()
	elseif b:current_syntax == "java" || b:current_syntax == "cs"
	    call <SID>Commentify_java()
	elseif b:current_syntax == "vim"
	    call <SID>Commentify_vim()
	elseif b:current_syntax == "tex"
	    call <SID>Commentify_tex()
	elseif b:current_syntax == "lua"
	    call <SID>Commentify_lua()
	else
	    call <SID>Commentify_perl()
	endif
    endif
endfunction

" F12 t commentifies or uncommentifies a single line.
nnoremap <f12>t :call <SID>Commentify()<CR>
inoremap <f12>t <esc>:call <SID>Commentify()<CR>
vnoremap <f12>t :call <SID>Commentify()<CR>

" ===== Buffer menu ===== {{{2
" VIM 5.4 and later comes with a buffer menu script so we don't need
" this one. However, that script is disabled for gui_athena so we have
" to use this one anyway if that is the case. In the VIM buffer menu
" script comments, it mentions that the code is disabled because you
" can't delete a menu item under gui_athena. This code here does not
" delete menu items so it will work.

if (version < 504 || has("gui_athena")) && has("autocmd")

    " Helper function for the buffers menu.
    " Go to the buffer if it is already loaded. Otherwise load the file.

    function! Goto_buf(bufnum, bufname)
	if bufexists(a:bufnum)
	    execute 'buffer' a:bufnum
	else
	    execute 'edit' a:bufname
	endif
    endfunction
    
    " This user-defined function adds the current buffer to the Buffers
    " menu. The menu action either switches to the buffer if the buffer
    " still exists, or loads the file if the buffer has been deleted.
    function! Menu_add_buf()
	let bufname = bufname("%")
	let bufnum = bufnr("%")
	if bufname != ""
	    let bufname = fnamemodify(bufname, ":p")
	    " The dot needs to be escaped too because it is a menu
	    " separator.
	    let bufname = escape(bufname, ' \.')
	    let bufcmd=':call Goto_buf('.bufnum.",'".bufname."')<cr>"
	    execute '80amenu &Buffers.'.bufname bufcmd
	endif
    endfunction

    " Add a List All menu item to the Buffers menu.
    80amenu &Buffers.List\ All<tab>:ls :ls<cr>

    augroup vimrc_buffers
	" Clear auto-commands.
	autocmd!

	" This will maintain a list of Buffers in a pull-down menu. Because
	" of vim problems, we do not remove deleted buffers from the menu.
	autocmd BufNewFile * call Menu_add_buf()
	autocmd BufReadPost * call Menu_add_buf()
	autocmd BufWritePost * call Menu_add_buf()
	autocmd BufEnter * call Menu_add_buf()
	autocmd WinEnter * call Menu_add_buf()
    augroup END
endif " version < 504 || has("gui_athena")

" ===== Insert/update timestamp ===== {{{2
" Returns the current date in string form.
" The substitution gets rid of the leading 0 in the day of the month.
function! <SID>Date_string()
    return substitute(strftime("%B %d, %Y"), " 0", " ", "")
endfunction

" F12 s inserts a date stamp.
" F12 s in visual mode replaces the selection with a date stamp.
nnoremap <F12>s i<C-R>=<SID>Date_string()<CR><ESC>
vnoremap <F12>s c<C-R>=<SID>Date_string()<CR><ESC>
inoremap <F12>s <C-R>=<SID>Date_string()<CR>

" F12 l updates a 'Last up-dated:' line
" Need to use a [s] here so that this macro won't change itself if
" invoked on this file.
let m = "1G/La[s]t updated:/e+0<CR>a <C-R>=<SID>Date_string()<CR><CR><ESC>dd"
execute "nnoremap <F12>l" m
execute "inoremap <F12>l <esc>" . m . "i"
execute "vnoremap <F12>l <esc>" . m
unlet m

" F12 u: This mapping will format any bullet list. It requires
" that there is an empty line above and below each list entry. The
" expression commands are used to be able to give comments to the
" parts of the mapping. (from the vim tips file)

let m =     ":noremap <f12>u :set ai<CR>"    " need 'autoindent' set
let m = m . "{O<Esc>"		      " add empty line above item
let m = m . "}{)^W"		      " move to text after bullet
let m = m . "i     <CR>     <Esc>"    " add space for indent
let m = m . "gq}"		      " format text after the bullet
let m = m . "{dd"		      " remove the empty line
let m = m . "5lDJ"		      " put text after bullet
execute m			      |" define the mapping
unlet m

" ===== Run ctags ===== {{{2
" F12 c runs ctags in the current file's directory.
" Under win32, run ctags in the current directory because we can't
" reliably do a cd.
function! <SID>Run_ctags()
    let ctagsrun = "ctags --if0 --totals --exclude=...* -n *.c *.cpp *.cc *.h"
    if has("win32")
	let ctagscmd = "!".ctagsrun
    else
	let ctagscmd = "!cd ".expand("%:p:h").";".ctagsrun
    endif
    execute ctagscmd
endfunction

nnoremap <F12>c :call <SID>Run_ctags()<cr>
vnoremap <F12>c <esc>:call <SID>Run_ctags()<cr>
inoremap <F12>c <esc>:call <SID>Run_ctags()<cr>

" ===== Customize vim modes ===== {{{2
" Function for setting up vim buffer defaults.
" This will be overridden by settings for C and perl below if
" applicable.
function! <SID>Set_default_mode()
    " No c indent mode.
    setlocal nocindent

    " No smart indenting by default.
    setlocal nosmartindent

    " Default format options.
    " Autowrap text and comments.
    " Allow formatting of comments with gq.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=tcq2

    " set default textwidth and shiftwidth 
    setlocal textwidth=75 shiftwidth=4
endfunction

" Function for setting up vim for editing C source files.
function! <SID>Set_c_mode()
    " set c indent mode for C source code
    setlocal cindent

    " set shiftwidth to 2, textwidth to 75
    setlocal shiftwidth=2 textwidth=75 

    setlocal cinoptions=>s,:0,=s,hs,ps,t0,+s,(0,g0

    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    setlocal comments=://,b:#,:%,:XCOMM,n:>,fb:- 
    " Fancy comments.
    setlocal comments+=s1:/*,mb:*,elx:*/

    " do not re-indent if the user types in a colon.
    setlocal cinkeys=0{,0},0#,!^F,o,O,e
endfunction

" Function for setting up vim for editing Java source files.
function! <SID>Set_java_mode()
    " set c indent mode for Java source code
    setlocal cindent

    " set shiftwidth to 4, textwidth to 75
    setlocal shiftwidth=4 textwidth=75 

    setlocal cinoptions=>s,:0,=s,hs,ps,t0,+s,(0,g0

    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    setlocal comments=:///,://,b:#,n:>,fb:-
    " Fancy comments.
    setlocal comments+=s1:/*,mb:*,elx:*/

    " do not re-indent if the user types in a colon.
    setlocal cinkeys=0{,0},0#,!^F,o,O,e

    " Use javacomplete.vim for omni-completion and user-completion.
    setlocal omnifunc=javacomplete#Complete
    setlocal completefunc=javacomplete#CompleteParamsInfo
endfunction

" Function for setting up vim to edit perl source files.
function! <SID>Set_perl_mode()
    " Turn on C indenting in Perl mode.
    " setlocal cindent

    " Set shiftwidth to 4.
    setlocal shiftwidth=4 textwidth=75

    " I prefer to indent by 4 spaces in perl programs.
    " setlocal cinoptions=>s,:0,=s,hs,ps,t0,+s,(0,g0

    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    " do not re-indent if the user types in a # sign or a colon
    " setlocal cinkeys=0{,0},!^F,o,O,e

    setlocal comments=:#
endfunction

" Function for setting up Vim to edit Python source files.
function! s:Set_python_mode()
    setlocal shiftwidth=4 textwidth=75
    
    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    setlocal comments=:#
endfunction

" Function for setting up Vim to edit CSS and Sass files.
function! s:Set_css_mode()
    setlocal shiftwidth=4 textwidth=75
    
    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    setlocal comments=s1:/*,mb:*,ex:*/,://
endfunction

" Fix for runtime/ftplugin/ruby.vim ruby_path
function! s:Get_ruby_path()
    if has("ruby") && has("win32")
	" ruby VIM::command('let ruby_path = "%s"' % ($: + begin; require %q{rubygems}; Gem.all_load_paths.sort.uniq; rescue LoadError; []; end).join(%q{,}) )
	ruby VIM::command('let ruby_path = "%s"' % ($: + begin; require %q{rubygems}; Gem::Specification.map(&:lib_dirs_glob).sort.uniq; rescue LoadError; []; end).join(%q{,}) )
	let ruby_path = '.,,' . substitute(ruby_path, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
    elseif executable("ruby")
	" let s:code = "print ($: + begin; require %q{rubygems}; Gem.all_load_paths.sort.uniq; rescue LoadError; []; end).join(%q{,})"
	let s:code = "print ($: + begin; require %q{rubygems}; Gem::Specification.map(&:lib_dirs_glob).sort.uniq;  rescue LoadError; []; end).join(%q{,})"
	if &shellxquote == "'"
	    let ruby_path = system('ruby -e "' . s:code . '"')
	else
	    let ruby_path = system("ruby -e '" . s:code . "'")
	endif
	let ruby_path = '.,,' . substitute(ruby_path, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
    else
	" If we can't call ruby to get its path, just default to using the
	" current directory and the directory of the current file.
	let ruby_path = ".,,"
    endif
    return ruby_path
endfunction

let g:ruby_path = s:Get_ruby_path()


" Function for setting up Vim to edit Ruby source files.
function! s:Set_ruby_mode()
    setlocal shiftwidth=2 textwidth=75
    
    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    setlocal expandtab

    setlocal comments=:#
endfunction

" Function for setting up vim to edit PHP source files.
function! <SID>Set_php_mode()
    " Turn on C indenting in PHP mode.
    " setlocal cindent

    " Set shiftwidth to 4.
    setlocal shiftwidth=4 textwidth=75

    " I prefer to indent by 4 spaces in PHP programs.
    " setlocal cinoptions=>s,:0,=s,hs,ps,t0,+s,(0,g0

    " Autowrap in comments but not in text
    " Automatically insert the comment leader after hitting Return in
    " insert mode or after hitting o or O in normal mode.
    " Use second line's indent to format the rest of the paragraph.
    setlocal formatoptions=cqro2l

    " do not re-indent if the user types in a # sign or a colon
    " setlocal cinkeys=0{,0},!^F,o,O,e

    setlocal comments=://,b:#,n:>,fb:-
    " Fancy comments.
    setlocal comments+=s1:/*,mb:*,elx:*/
endfunction

" Function for setting up vim to edit DOS batch files.
function! <SID>Set_batch_mode()
    " Set shiftwidth to 4.
    setlocal shiftwidth=4 textwidth=0
endfunction

if has("autocmd")
    augroup vimrc_auto
	" Clear all auto-commands.
	autocmd!

	autocmd BufNewFile,BufReadPre * call <SID>Set_default_mode()
	autocmd FileType c,cpp call <SID>Set_c_mode()

	" Use Java mode for C# source files too.
	autocmd FileType java,cs call <SID>Set_java_mode()

	autocmd FileType perl call <SID>Set_perl_mode()
	autocmd FileType php call <SID>Set_php_mode()
	autocmd FileType dosbatch,sh call <SID>Set_batch_mode()
	autocmd FileType ruby,eruby call <SID>Set_ruby_mode()
	autocmd FileType python call <SID>Set_python_mode()
	autocmd FileType css,scss call <SID>Set_css_mode()

	" Clear some artifacts in console Vim.
	autocmd VimEnter * redraw

	autocmd BufRead,BufNewFile *.thrift set filetype=thrift
	autocmd Syntax thrift source ~/.vim/thrift.vim

    augroup END
endif

" ===== Toggle line break mode ===== {{{2
" Function for changing options so that we can edit paragraphs without
" a line break.
function! <SID>Set_no_lbr()
    " Break lines onscreen at words.
    set linebreak
    " Map up and down keys to line-oriented up and down.
    nnoremap <buffer> <Up> gk
    vnoremap <buffer> <Up> gk
    inoremap <buffer> <Up> <C-o>gk
    nnoremap <buffer> <Down> gj
    vnoremap <buffer> <Down> gj
    inoremap <buffer> <Down> <C-o>gj
    " Map home and end keys to line-oriented home and end.
    nnoremap <buffer> <Home> g0
    vnoremap <buffer> <Home> g0
    inoremap <buffer> <Home> <C-o>g0
    nnoremap <buffer> <End> g$
    vnoremap <buffer> <End> g$
    inoremap <buffer> <End> <C-o>g$
endfunction

" Reset all the options set by Set_no_lbr()
function! <SID>Reset_no_lbr()
    " Do not break lines at words.
    set nolinebreak
    " Remove mappings for the up and down keys.
    nunmap <buffer> <Up>
    vunmap <buffer> <Up>
    iunmap <buffer> <Up>
    nunmap <buffer> <Down>
    vunmap <buffer> <Down>
    iunmap <buffer> <Down>
    " Remove mappings for the home and end keys.
    nunmap <buffer> <Home>
    vunmap <buffer> <Home>
    iunmap <buffer> <Home>
    nunmap <buffer> <End>
    vunmap <buffer> <End>
    iunmap <buffer> <End>
endfunction

function! <SID>Toggle_no_lbr()
    if &linebreak
	call <SID>Reset_no_lbr()
    else
	call <SID>Set_no_lbr()
    endif
    set linebreak?
endfunction

" F3 toggles no-linebreak mode
nnoremap <F3> :call <SID>Toggle_no_lbr()<cr>
vnoremap <F3> <esc>:call <SID>Toggle_no_lbr()<cr>
inoremap <F3> <esc>:call <SID>Toggle_no_lbr()<cr>

" ===== Command-line completion ===== {{{2
"
" Based on:
" http://vim.sourceforge.net/scripts/script.php?script_id=474
" http://vim.sourceforge.net/scripts/script.php?script_id=147
"
" Adds the ability to word-complete in a regular (non-search) command-line
" and to word-complete in the middle of the command-line.

let s:lastcmdline = ""
let s:lastcmdpos = ""

function! <SID>CmdlineComplete()
    let cmdline = getcmdline()
    let cmdpos = getcmdpos()
    if cmdline == s:lastcmdline && cmdpos == s:lastcmdpos
	" User invoked completion again without moving cursor or editing
	let cmdline = s:origcmdline
	let cmdpos = s:origcmdpos
	let s:completeDepth = s:completeDepth . "\<C-N>"
    else
	" Starting new completion
	let s:origcmdline = cmdline
	let s:origcmdpos = cmdpos
	let s:completeDepth = "\<C-N>"
    endif

    " Set paste option to disable indent
    let paste = &l:paste
    setlocal paste

    let savecol = col(".")

    execute "normal! o" . cmdline . "\<C-O>" . cmdpos . "|" . s:completeDepth

    " Update the command line and position.
    let s:lastcmdline = getline(".")
    let s:lastcmdpos = col(".") + 1

    " Check if we have come full circle and reset the search depth. This
    " needs to be done because Vim behaves in a weird way if too many
    " Ctrl-Ns are used in a macro.
    if s:lastcmdline == s:origcmdline
	let s:completeDepth = ""
    endif

    " Undo changes and restore cursor position
    execute "normal! u" . savecol . "|"

    " Restore paste option
    let &l:paste = paste

    let tmp = setcmdpos(s:lastcmdpos)
    return s:lastcmdline
endfunction

" cnoremap <F12> <C-\>e<SID>CmdlineComplete()<cr>


" ===== Convert to decimal coordinates ===== {{{2
" For converting coordinates from N ddd mm.mmm W ddd mm.mmm to 
" dd.ddddd -dd.ddddd

function! <SID>ToDecimals(deg, minwhole, mindec)
    " Trim leading zeros so that the string won't be treated as octal.
    let deg = substitute(a:deg, "^0*", "", "")
    let minwhole = substitute(a:minwhole, "^0*", "", "")

    " Force the decimal portion of the minutes to be 3 decimal places.
    " And then trim leading zeros.
    let mindec = substitute(strpart(a:mindec.'000', 0, 3), "^0*", "", "")

    let val = (minwhole * 1000000 + mindec * 1000 + 30) / 60
    return deg . "." . strpart("000000", 0, 6 - strlen(val)) . val
endfunction

function! <SID>ConvertCoords()
    let coord = '\(\d\+\)\D\+\(\d\+\)\D\+\(\d\+\)'
    let x = substitute(getline("."), '\D*'.coord.'\D\+'.coord.'.*', '\=<SID>ToDecimals(submatch(1), submatch(2), submatch(3)) . "\<cr>-" . <SID>ToDecimals(submatch(4), submatch(5), submatch(6))', "")
    execute "normal o\<home>" . x . "\<esc>"
endfunction

nnoremap <f12>g :call <SID>ConvertCoords()<cr>
vnoremap <f12>g <esc>:call <SID>ConvertCoords()<cr>

" ------------------------------------------------------------------
" Convert geocaching URL followed by cache name into a HTML link.
"     function! Convert_gc_url()
" 	s+^\([^ ]*?\)[^ ]*\(ID=\d\+\)[^ ]* \+\(.*\)$+<p><a href="\1pf=y\&\2\&log=y\&decrypt=y">\3</a>+e
"     endfunction

"     map ,c :call Convert_gc_url()<cr>
"     vmap ,c :call Convert_gc_url()<cr>
"     imap ,c <esc>:call Convert_gc_url()<cr>

" ===== Generate HTML geocache link ===== {{{2
" convert waypoint to ID number
" returns -1 if invalid waypoint
function! s:GCtoID(waypt)
    let waypt = toupper(a:waypt)
    let WPTCHARS = "0123456789ABCDEFGHJKMNPQRTVWXYZ"

    if match(waypt, '^GC[0-9A-F]\{1,4}$') >= 0
	return "0x" . strpart(waypt, 2) + 0
    " elseif match(waypt, '^GC[GHJ-KM-NP-RTV-Z][0-9A-HJ-KM-NP-RTV-Z]\{3}$') >= 0
    elseif match(waypt, '^GC[' . strpart(WPTCHARS, 16) . '][' . WPTCHARS . ']\{3}$') >= 0
	let accum = 0
	let i = 2
	while i < 6
	    " echo waypt[i]
	    let accum = accum * 31 + match(WPTCHARS, waypt[i])
	    if i == 2
		let accum = accum - 16
	    endif
	    let i = i + 1
	endwhile
	return accum + 65536
    elseif match(waypt, '^GC[' . WPTCHARS . ']\{5}$') >= 0
	let accum = 0
	let i = 2
	while i < 7
	    let accum = accum * 31 + match(WPTCHARS, waypt[i])
	    if i == 2
		let accum = accum - 1
	    endif
	    let i = i + 1
	endwhile
	return accum + 512401
    else
	return -1
    endif
endfunction

" ,c Convert a line of the form
" waypt cache-title
" into a HTML geocache link.
function! <SID>ConvertGC()

    let gcregex = 'GC[0-9A-Za-z]\{1,5}'

    let fmt1 = '^\s*\d\+\.\s\+\(.*\)\s\+(.\{-})\s\+(\('.gcregex.'\))\s*$'
    let fmt2 = '^\s*\(.*\)\s\+by\s\+.\{-}\s\+(\('.gcregex.'\))\s*$'
    let fmt3 = '^\s*\('.gcregex.'\)\s\+\(.\{-}\)\s*$'

    let line = getline(".")
    let waypt = ""
    let title = ""

    let res = matchlist(line, fmt1)
    if res != []
	let waypt = res[2]
	let title = res[1]
    else
	let res = matchlist(line, fmt2)
	if res != []
	    let waypt = res[2]
	    let title = res[1]
	else
	    let res = matchlist(line, fmt3)
	    if res != []
		let waypt = res[1]
		let title = res[2]
	    endif
	endif
    endif

    let title = substitute(title, '&', '\&amp;', 'g')
    let title = substitute(title, '<', '\&lt;', 'g')
    let title = substitute(title, '>', '\&gt;', 'g')

"    echo "waypt = ". waypt. ", title = ". title . "."

    let id = s:GCtoID(waypt)
    if id >= 0
	call setline(".", "<p><a href=\"http://www.geocaching.com/seek/cache_details.aspx?pf=y&ID=" . id . "&log=y&decrypt=y\">" . title . "</a>")
    endif
endfunction

nnoremap ,c :call <SID>ConvertGC()<cr>
vnoremap ,c :call <SID>ConvertGC()<cr>

" ===== Convert My Caches HTML to list of links. (new) ===== {{{2

" Get the content of the n'th element in a series of elements.
function! s:xml_get_nth(xmlstr, elem, n)
    let matchres = matchlist(a:xmlstr, '<'.a:elem.'\%( [^>]*\)\?>\(.\{-}\)</'.a:elem.'>', -1, a:n)
    return matchres == [] ? "" : matchres[1]
endfunction

" Remove leading and trailing whitespace.
function! s:trim_both(s)
    " Remove trailing whitespace.
    let s = substitute(a:s, '\s\+$', '', '')

    " Remove leading whitespace.
    return substitute(s, '^\s\+', '', '')
endfunction

" ,M Convert new-style my caches HTML to a list of links.
function! s:Convert_mycaches_3() range
    let m1 = 'http://www\.geocaching\.com/seek/cache_details\.aspx[^"]*'
    let m2 = '<a href="'.m1.'">\(.*\)</a>'

    let header = '<lj-cut text="The caches...">'."\<cr>".'<div style="margin: 10px 30px; border: 1px dashed; padding: 10px;">'."\<cr>"
    let footer = '</div>'."\<cr>".'</lj-cut>'."\<cr>"

    let outstr = ""
    let str = join(getline(a:firstline, a:lastline), "")

    " Remove ^M characters.
    let str = substitute(str, '\r', '', 'g')

    let trcount = 1
    while 1
	let logitem = s:xml_get_nth(str, 'tr', trcount)
	if logitem == ""
	    break
	endif

	let linkitem = s:xml_get_nth(logitem, 'td', 3)

	" Get cache link.
	let linkstr = matchstr(linkitem, m1, 0)
	if linkstr != ""

	    " Get cache name.
	    let matchres = matchlist(linkitem, m2)
	    let name = s:trim_both(matchres[1])

	    let state = s:trim_both(s:xml_get_nth(logitem, 'td', 4))
	    
	    let link = '<a href="'.linkstr.'">'.name.' ('.state.")</a>\r"

	    " Prepend to reverse the order of the log items.
	    let outstr = link . outstr
	endif

	let trcount += 1
    endwhile

    " Pick the correct change command so that autoindent is not in effect.
    " We want the inserted lines to have no indent.
    let changecmd = &autoindent ? "change!" : "change"
    silent execute "normal :" . a:firstline . "," . a:lastline . changecmd . "\<cr>" . header . outstr . footer . "\<esc>"
endfunction

vnoremap ,M :call <SID>Convert_mycaches_3()<cr>

" ===== Convert text to HTML ===== {{{2
" Convert text to HTML by escaping <, >, ", and &.
function! <SID>HtmlizeText()
    let line = getline(".")
    let line = substitute(line, '&', '\&amp;', 'g')
    let line = substitute(line, '<', '\&lt;', 'g')
    let line = substitute(line, '>', '\&gt;', 'g')
    let line = substitute(line, '"', '\&quot;', 'g')
    call setline(".", line)
endfunction

nnoremap ,h :call <SID>HtmlizeText()<cr>
vnoremap ,h :call <SID>HtmlizeText()<cr>

" ===== Convert Topozone URL to Geobloggers tags for Flickr. ===== {{{2
function! <SID>ConvertGeoTag()
    let coords = '.\{-}\(\d\+\.\d\+\).\{-}\(-\d\+\.\d\+\).*'
    let x = substitute(getline("."), coords, 'geotagged geo:lat=\1 geo:lon=\2', '')
    execute "normal o" . x . "\<cr><a href=\"http://www.geobloggers.com\">geotagged</a>\<esc>"
endfunction

nnoremap ,f :call <SID>ConvertGeoTag()<cr>
vnoremap ,f <esc>:call <SID>ConvertGeoTag()<cr>

" ===== Add LJ user tag around the current word. ===== {{{2
nnoremap ,u ciw<lj user="<c-r>""><esc>
vnoremap ,u c<lj user="<c-r>""><esc>

nnoremap ,U ciw<lj comm="<c-r>""><esc>
vnoremap ,U c<lj comm="<c-r>""><esc>

" Update for Dreamwidth. Use this for both users and communities.
nnoremap ,u ciw<user name="<c-r>"" site="livejournal.com"><esc>
vnoremap ,u c<user name="<c-r>"" site="livejournal.com"><esc>

" ===== Use the Silver Searcher for searching, if available ===== {{{2
" Borrowed from: http://robots.thoughtbot.com/faster-grepping-in-vim/

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " Don't use this if we have the ag plugin.
  " command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
endif

" }}}1
" ----- Local vimrc ----- {{{1

" Source a local vimrc file if one exists. This is useful for
" customizations that differ from system to system.
if $HOME != "" && filereadable($HOME."/vimrc.local")
    execute "source ".$HOME."/vimrc.local"
elseif $VIM != "" && filereadable($VIM."/vimrc.local")
    execute "source ".$VIM."/vimrc.local"
endif

" }}}1

" Last updated: January 23, 2014
" vim:fo=cqro tw=75 com=\:\" sw=4 
