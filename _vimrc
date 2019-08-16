" ----- General Options ----- {{{1

" Set the character encoding used inside Vim.
" This option has to come before autochdir in order to not trigger
" a bug with relative pathnames on Vim startup.
set encoding=utf-8
" Do not automatically change directories.
" silent! is needed because this option is not available unless certain
" features have been enabled.
silent! set noautochdir

if has('autocmd')
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
set backspace=indent,eol,start
" don't leave backup files
set nobackup

" If the clipboard register is available, use it for all yank, delete,
" change and put operations.
function! s:got_clipboard()
    if !has('clipboard')
        return 0
    endif
    let l:save_clip = @*
    let @* = 'xx'
    let l:retval = @* ==# 'xx'
    let @* = l:save_clip
    return l:retval
endfunction

function! <SID>set_clipboard()
    " echom "Got clipboard = ".s:got_clipboard()
    set clipboard-=unnamed
    if s:got_clipboard()
        set clipboard+=unnamed
    endif
endfunction

" :write command with a file name sets alternate file name for the current
" window.
" :write command with a file name sets name of buffer if the buffer does not
" have a name.
" set buffer options when first entering a buffer
set cpoptions=AFs

" Use histogram diff algorithm and indent heuristic.
if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif

" Set swapfile location.
let s:vimrc_swapdir = expand('~/vim/swapdir')
if !isdirectory(s:vimrc_swapdir)
    call mkdir(s:vimrc_swapdir, 'p', 0700)
endif
execute 'set directory^='.s:vimrc_swapdir

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
" Disable menus.
set guioptions-=m
" Visual mode controls global window system selection.
" set guioptions+=a
" Use console dialogs.
set guioptions+=c
" Disable toolbar.
set guioptions-=T
" Disable scrollbars.
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
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
" make non-breaking spaces visible
set listchars+=nbsp:%
" magic search patterns
set magic
" Enable mouse in console Vim.
set mouse=a
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
" For coc.nvim, don't give |ins-completion-menu| messages.
set shortmess+=c
" Truncate long messages.
set shortmess+=T
" For coc.nvim, always show signcolumns
set signcolumn=yes
" override ignorecase if search pattern contains upper case characters
set smartcase
" Customize status line
if v:version >= 700
    set statusline=%f%#User1#
else
    set statusline=%f%1*
endif
set statusline+=\ [%M%R%W]\ [%{&fileformat}]%y\ B%n%a
set statusline+=\ %=L%l/%L\ C%-4(%c%V/%{strlen(getline('.'))}%)\ %3p%%
" match .err (Watcom C++ errors) files last
" match graphics files and executables last
set suffixes+=.err
set suffixes+=.gif
set suffixes+=.jpg
set suffixes+=.png
set suffixes+=.exe
set suffixes+=.dll
" mode for fast tty
set ttyfast

" Enable persistent undo
if has('persistent_undo')
    let s:vimrc_undodir = expand('~/vim/undodir')
    if !isdirectory(s:vimrc_undodir)
        call mkdir(s:vimrc_undodir, 'p', 0700)
    endif
    execute 'set undodir^='.s:vimrc_undodir
    set undofile
endif

" For coc.nvim diagnostic messages.
set updatetime=300

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

" ===== Install vim-plug and plugins =====

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'

Plug 'artnez/vim-wipeout'
" F12 F4 wipes out non-visible buffers.
nnoremap <F12><F4> :Wipeout<cr>
vnoremap <F12><F4> <esc>:Wipeout<cr>gv
inoremap <F12><F4> <C-o>:Wipeout<cr>

" Plug 'atweiden/vim-dragvisuals'
" Map ctrl-h/j/k/l in visual mode to drag the block.
" vmap <expr> <C-h> DVB_Drag('left')
" vmap <expr> <C-l> DVB_Drag('right')
" vmap <expr> <C-k> DVB_Drag('up')
" vmap <expr> <C-j> DVB_Drag('down')
" vmap <expr> ,d DVB_Duplicate() 

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ 'python': ['/usr/local/bin/pyls'],
"     \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
"     \ }

" " Shift-F5 brings up LanguageClient context menu.
" nnoremap <S-F5> :call LanguageClient_contextMenu()<CR>

" set completefunc=LanguageClient#complete

Plug 'chrisbra/csv.vim'
" Don't conceal delimiters.
let g:csv_no_conceal = 1
" Customize CSV highlights.
highlight CSVColumnEven guifg=gray guibg=#000066 ctermfg=gray ctermbg=DarkBlue
highlight CSVColumnOdd guifg=gray guibg=black ctermfg=gray ctermbg=black
highlight CSVDelimiter guifg=cyan guibg=black ctermfg=cyan ctermbg=black
highlight CSVColumnHeaderEven guifg=green guibg=#000066 ctermfg=green ctermbg=DarkBlue
highlight CSVColumnHeaderOdd guifg=green guibg=black ctermfg=green ctermbg=black

Plug 'ctrlpvim/ctrlp.vim'
" Use CtrlPMRU as default.
let g:ctrlp_cmd = 'CtrlPMRUFiles'
" Increase size of MRU cache.
let g:ctrlp_mruf_max = 2000
" Don't jump to an existing window when opening a file.
let g:ctrlp_switch_buffer = ''
" F12 F12: Invoke CtrlP in buffer mode.
nnoremap <F12><F12> :CtrlPBuffer<cr>
vnoremap <F12><F12> <esc>:CtrlPBuffer<cr>
inoremap <F12><F12> <esc>:CtrlPBuffer<cr>

Plug 'dhruvasagar/vim-vinegar'
Plug 'elixir-lang/vim-elixir'

" Plug 'gabesoft/vim-ags'
" The following autocmd fixes a weird issue with syntax highlighting in the
" vim-ags search results window.
autocmd BufNewFile,BufRead *.agsv call s:Turn_syntax_on()

Plug 'godlygeek/tabular'

" Plug 'haya14busa/incsearch.vim'
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)

" set hlsearch
" let g:incsearch#auto_nohlsearch = 1
" map n  <Plug>(incsearch-nohl-n)
" map N  <Plug>(incsearch-nohl-N)
" map *  <Plug>(incsearch-nohl-*)
" map #  <Plug>(incsearch-nohl-#)
" map g* <Plug>(incsearch-nohl-g*)
" map g# <Plug>(incsearch-nohl-g#)
" nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
" nnoremap v :<C-u>nohlsearch<cr>v
" nnoremap V :<C-u>nohlsearch<cr>V
" nnoremap <C-v> :<C-u>nohlsearch<cr><C-v>

" let g:incsearch#consistent_n_direction = 1

" augroup incsearch-keymap
"     autocmd!
"     autocmd VimEnter * call s:incsearch_keymap()
" augroup END
" function! s:incsearch_keymap()
"     IncSearchNoreMap <C-f> <Over>(incsearch-scroll-f)
"     IncSearchNoreMap <C-b> <Over>(incsearch-scroll-b)
"     IncSearchNoreMap <PageDown> <Over>(incsearch-scroll-f)
"     IncSearchNoreMap <PageUp> <Over>(incsearch-scroll-b)
"     IncSearchNoreMap <Right> <Over>(incsearch-next)
"     IncSearchNoreMap <Left>  <Over>(incsearch-prev)
"     IncSearchNoreMap <Tab> <Over>(buffer-complete)
" endfunction

" Plug 'jnwhiteh/vim-golang'
" Plug 'JarrodCTaylor/vim-shell-executor'

Plug 'jistr/vim-nerdtree-tabs'
" Don't open NERDTree on GUI startup.
let g:nerdtree_tabs_open_on_gui_startup = 0
" F7 will toggle NERDTree.
nmap <silent> <F7> <plug>NERDTreeTabsToggle<CR>
vmap <silent> <F7> <esc><plug>NERDTreeTabsToggle<CR>gv
imap <silent> <F7> <C-O><plug>NERDTreeTabsToggle<CR>

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" let g:fzf_launcher = '/Users/pcheah/bin/in_a_new_term.sh %s'

Plug 'junegunn/vim-easy-align'
" F12 a invokes EasyAlign.
nmap <F12>a <Plug>(EasyAlign)
vmap <F12>a <Plug>(EasyAlign)

" To get Vim help for vim-plug itself.
Plug 'junegunn/vim-plug'

Plug 'kchmck/vim-coffee-script'

" Plug 'kien/rainbow_parentheses.vim'
" " F8 toggles rainbow parentheses.
" nnoremap <F8> :RainbowParenthesesToggle<cr>
" vnoremap <F8> <esc>:RainbowParenthesesToggle<cr>gv
" inoremap <F8> <c-o>:RainbowParenthesesToggle<cr>

Plug 'ludovicchabant/vim-gutentags'
set statusline+=%{gutentags#statusline('\ [TAGS]')}
let g:gutentags_cache_dir='~/vim/gutentags'
let g:gutentags_project_root=['.svn']

Plug 'mhinz/vim-grepper'
let g:grepper = {}
let g:grepper.dir = 'repo,filecwd'

" Plug 'mileszs/ack.vim'
Plug 'moll/vim-bbye'

" Plug 'mortonfox/nerdtree-ags'
Plug 'mortonfox/nerdtree-clip'

Plug 'mortonfox/nerdtree-iterm'
let g:nerdtree_iterm_iterm_version = 3

" Plug 'mortonfox/nerdtree-reuse-currenttab'
Plug 'mortonfox/nerdtree-reuse-none'

Plug 'mortonfox/QuickBuf'
" Shift-F4 brings up QuickBuf.
let g:qb_hotkey = '<S-F4>'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'ngmy/vim-rubocop'
Plug 'pangloss/vim-javascript'
" Plug 'qpkorr/vim-bufkill'
" Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'

Plug 'scrooloose/nerdtree'
let g:NERDTreeCascadeSingleChildDir=0
" Ctrl-F7 finds the current file in the NERDTree.
nnoremap <silent> <S-F7> :NERDTreeFind<CR>
vnoremap <silent> <S-F7> <esc>:NERDTreeFind<CR>
inoremap <silent> <S-F7> <C-O>:NERDTreeFind<CR>

" Plug 'scrooloose/syntastic'
" Turn off syntastic balloons.
" let g:syntastic_enable_balloons = 0

Plug 'simnalamburt/vim-mundo'
nnoremap <F9> :silent MundoToggle<CR>
let g:mundo_right = 1

" Plug 'sjl/gundo.vim'
" nnoremap <F9> :silent GundoToggle<CR>
" let g:gundo_right = 1

Plug 'solarnz/thrift.vim'

Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'

Plug 'tpope/vim-commentary'
let g:commentary_map_backslash=0

" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'

Plug 'udalov/kotlin-vim'

Plug 'vimoutliner/vimoutliner'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/Align'

Plug 'w0rp/ale'
let g:ale_ruby_rubocop_options = '--lint'
let g:ale_set_balloons = 0

Plug 'yegappan/mru'

Plug 'zirrostig/vim-schlepp'
" Map ctrl-h/j/k/l in visual mode to drag the block.
vmap <C-h> <Plug>SchleppUp
vmap <C-l> <Plug>SchleppDown
vmap <C-k> <Plug>SchleppLeft
vmap <C-j> <Plug>SchleppRight
vmap ,d <Plug>SchleppDup

" Plug 'twitvim/twitvim'
" Plug 'file:///Users/pcheah/proj/twitvim'

call plug#end()

" ===== Other Initialization ===== {{{2

" Make filetype.vim treat .h files as C files.
" let c_syntax_for_h=1

" runtime! ftdetect/*.vim
runtime macros/matchit.vim

" Make vimpager use MacVim.
" Assuming that .vimpagerrc sources this file.
let g:vimpager_use_gvim = 1

" ----- GUI customization ----- {{{1

" In vim 5.4 with GTK+, the .font resource does not work.
if has('gui_gtk') && has('gui_running')
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

if has('mac') && has('gui_running')
    " Special font for the Mac
    if hostname() =~? '^donhaven'
        " Use smaller font on my laptop.
        set guifont=monaco:h13
    else
        set guifont=monaco:h14
    endif

    " Map cmd-1 thru cmd-9 to switch tabs.
    nnoremap <silent> <D-1> :silent! 1tabnext<cr>
    nnoremap <silent> <D-2> :silent! 2tabnext<cr>
    nnoremap <silent> <D-3> :silent! 3tabnext<cr>
    nnoremap <silent> <D-4> :silent! 4tabnext<cr>
    nnoremap <silent> <D-5> :silent! 5tabnext<cr>
    nnoremap <silent> <D-6> :silent! 6tabnext<cr>
    nnoremap <silent> <D-7> :silent! 7tabnext<cr>
    nnoremap <silent> <D-8> :silent! 8tabnext<cr>
    nnoremap <silent> <D-9> :silent! 9tabnext<cr>
endif

" If the gvim window is too small, try setting it larger.
if &lines < 40 && has('gui_running')
    set lines=40
endif

" ----- Hotkey Customization ----- {{{1

" shift-insert will now paste text from clipboard
nnoremap <S-Insert> "*P
vnoremap <S-Insert> "-d"*P
noremap! <S-Insert> <C-R><C-R>*
vnoremap <C-Insert> "*y
vnoremap <S-Delete> "*d
vnoremap <C-Delete> "*d

" ctrl-tab, ctrl-shift-tab moves between tabs
nnoremap <C-Tab> gt
vnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
vnoremap <C-S-Tab> gT

" Map ctrl-h/j/k/l to move to other windows.
" Idea borrowed from spf13-vim. (http://vim.spf13.com/)
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j

" map F2 key to save file in insert and command modes
nnoremap <F2> :write<CR>
vnoremap <F2> <esc>:write<CR>gv
inoremap <F2> <C-O>:write<CR>

" F3 toggles no-linebreak mode
nnoremap <F3> :call <SID>Toggle_no_lbr()<cr>
vnoremap <F3> <esc>:call <SID>Toggle_no_lbr()<cr>gv
inoremap <F3> <esc>:call <SID>Toggle_no_lbr()<cr>

" F4 toggles list mode
nnoremap <F4> :set invlist list?<cr>
vnoremap <F4> <esc>:set invlist list?<cr>gv
inoremap <F4> <C-o>:set invlist list?<cr>

" F5 toggles paste mode
nnoremap <F5> :set invpaste paste?<CR>
vnoremap <F5> <esc>:set invpaste paste?<CR>gv
" pastetoggle key in vim 5.4 allows us to get out of paste mode
" even from within insert mode.
inoremap <F5> <C-O>:set invpaste<CR>
set pastetoggle=<F5>

" Map F6 key to go to the next buffer and Shift-F6 to go to the previous
" buffer.
nnoremap <F6> :bnext<CR>
vnoremap <F6> <esc>:bnext<CR>
inoremap <F6> <C-O>:bnext<CR>
nnoremap <S-F6> :bprevious<CR>
vnoremap <S-F6> <esc>:bprevious<CR>
inoremap <S-F6> <C-O>:bprevious<CR>

" Ctrl-F8 toggles syntax coloring on and off
nnoremap <C-F8> :call <SID>Toggle_syntax()<cr>
vnoremap <C-F8> <esc>:call <SID>Toggle_syntax()<cr>gv
inoremap <C-F8> <esc>:call <SID>Toggle_syntax()<cr>

" Shift-F8 will show syntax item at cursor
nnoremap <S-F8> :echo synIDattr(synID(line("."), col("."), 1), "name")<CR>
vnoremap <S-F8> <esc>:echo synIDattr(synID(line("."), col("."), 1), "name")<CR>gv
inoremap <S-F8> <esc>:echo synIDattr(synID(line("."), col("."), 1), "name")<CR>

" F9 will toggle taglist.
" nnoremap <silent> <F9> :TlistToggle<cr>
" vnoremap <silent> <F9> <esc>:TlistToggle<cr>
" inoremap <silent> <F9> <C-O>:TlistToggle<cr>

" let Tlist_Process_File_Always = 1
" let Tlist_Use_Right_Window = 1
" let Tlist_Inc_Winwidth = 0
" let Tlist_Show_Menu = 1

" Ctrl-F9 toggles full height mode
nnoremap <C-F9> :call <SID>Toggle_full_height()<cr>
vnoremap <C-F9> <esc>:call <SID>Toggle_full_height()<cr>gv
inoremap <C-F9> <esc>:call <SID>Toggle_full_height()<cr>

" F11 c: change current directory to the directory in which the current
" file resides.
nnoremap <F11>c :cd <C-R>=expand("%:p:h")<cr><cr>
vnoremap <F11>c <esc>:cd <C-R>=expand("%:p:h")<cr><cr>
inoremap <F11>c <esc>:cd <C-R>=expand("%:p:h")<cr><cr>

" F11 h: startup directory (home)
let s:startdir=getcwd()
function! <SID>GetStartDir()
    return s:startdir
endfunction
nnoremap <F11>h :execute "cd" '<c-r>=<SID>GetStartDir()<cr>'<cr>:pwd<cr>
vnoremap <F11>h <esc>:execute "cd" '<c-r>=<SID>GetStartDir()<cr>'<cr>:pwd<cr>
inoremap <F11>h <esc>:execute "cd" '<c-r>=<SID>GetStartDir()<cr>'<cr>:pwd<cr>

" F12 a runs tal on the current paragraph or visual range.
" F12 A does the same thing but waits for user to type in arguments.
" nnoremap <F12>a {!}tal<cr>
" inoremap <F12>a <esc>{!}tal<cr>
" vnoremap <F12>a !tal<cr>
" nnoremap <F12>A {!}tal<space>
" inoremap <F12>A <esc>{!}tal<space>
" vnoremap <F12>A !tal<space>

" F12 b runs boxes on the current paragraph or visual range.
" F12 B does the same thing but waits for user to type in arguments.
nnoremap <F12>b {!}boxes<cr>
inoremap <F12>b <esc>{!}boxes<cr>
vnoremap <F12>b !boxes<cr>
nnoremap <F12>B {!}boxes<space>
inoremap <F12>B <esc>{!}boxes<space>
vnoremap <F12>B !boxes<space>

" F12 c runs ctags in the current file's directory.
nnoremap <F12>c :call <SID>Run_ctags()<cr>
vnoremap <F12>c <esc>:call <SID>Run_ctags()<cr>gv
inoremap <F12>c <esc>:call <SID>Run_ctags()<cr>

" F12 d removes all buffers.
nnoremap <F12>d :call <SID>Del_all_buf()<cr>
vnoremap <F12>d <esc>:call <SID>Del_all_buf()<cr>
inoremap <F12>d <esc>:call <SID>Del_all_buf()<cr>

" F12 e: edit another file in the same directory as the current file.
set wildcharm=<c-z>
nnoremap <F12>e :e <C-R>=expand("%:p:h")."/"<cr><c-z><s-tab>
vnoremap <F12>e <esc>:e <C-R>=expand("%:p:h")."/"<cr><c-z><s-tab>
inoremap <F12>e <esc>:e <C-R>=expand("%:p:h")."/"<cr><c-z><s-tab>

" F12 g converts coordinates from N ddd mm.mmm W ddd mm.mmm to 
" dd.ddddd -dd.ddddd
nnoremap <f12>g :call <SID>ConvertCoords()<cr>
vnoremap <f12>g <esc>:call <SID>ConvertCoords()<cr>gv

" F12 l updates a 'Last up-dated:' line
" Need to use a [s] here so that this macro won't change itself if
" invoked on this file.
let s:m = '1G/La[s]t updated:/e+0<CR>a <C-R>=<SID>Date_string()<CR><CR><ESC>dd'
execute 'nnoremap <F12>l' s:m
execute 'inoremap <F12>l <esc>' . s:m . 'i'
execute 'vnoremap <F12>l <esc>' . s:m . 'gv'
unlet s:m

" F12 m runs Marked on the Markdown file.
function! s:Run_marked()
    silent !open -a "Marked 2" %
    redraw!
endfunction
augroup markdown_auto
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <F12>m :call <SID>Run_marked()<cr>
augroup END

" F12 p runs par on the current paragraph or visual range
" F12 P does the same thing but waits for user to type in arguments.
nnoremap <F12>p {!}par<cr>
inoremap <F12>p <esc>{!}par<cr>
vnoremap <F12>p !par<cr>
nnoremap <F12>P {!}par<space>
inoremap <F12>P <esc>{!}par<space>
vnoremap <F12>P !par<space>

" F12 s inserts a date stamp.
" F12 s in visual mode replaces the selection with a date stamp.
nnoremap <F12>s i<C-R>=<SID>Date_string()<CR><ESC>
vnoremap <F12>s c<C-R>=<SID>Date_string()<CR><ESC>
inoremap <F12>s <C-R>=<SID>Date_string()<CR>

" F12 u: This mapping will format any bullet list. It requires
" that there is an empty line above and below each list entry. The
" expression commands are used to be able to give comments to the
" parts of the mapping. (from the vim tips file)

let s:m =     ':noremap <f12>u :set ai<CR>'    " need 'autoindent' set
let s:m = s:m . '{O<Esc>'                 " add empty line above item
let s:m = s:m . '}{)^W'                   " move to text after bullet
let s:m = s:m . 'i     <CR>     <Esc>'    " add space for indent
let s:m = s:m . 'gq}'                     " format text after the bullet
let s:m = s:m . '{dd'                     " remove the empty line
let s:m = s:m . '5lDJ'                    " put text after bullet
execute s:m                             |" define the mapping
unlet s:m

" F12 ve edits .vimrc file
" F12 vs sources .vimrc file (Breaks coc.nvim. Do not use.)
nnoremap <F12>ve :edit $MYVIMRC<cr>
" nnoremap <F12>vs :source $MYVIMRC<cr>

" F12 x runs boxes -r on the current paragraph or visual range.
" F12 X does the same thing but waits for user to type in arguments.
nnoremap <F12>x {!}boxes -r<cr>
inoremap <F12>x <esc>{!}boxes -r<cr>
vnoremap <F12>x !boxes -r<cr>
nnoremap <F12>X {!}boxes -r<space>
inoremap <F12>X <esc>{!}boxes -r<space>
vnoremap <F12>X !boxes -r<space>

" iTerm2 sends nul characters for anti-idle. Ignore those characters in
" text mode.
if has('mac') && !has('gui_running')
    inoremap <C-@> <Nop>
    cnoremap <C-@> <Nop>
    lnoremap <C-@> <Nop>
endif

" Allow saving of files as sudo when I forgot to start vim using sudo.
" See: http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! w !sudo tee > /dev/null %

" Replace words with gn command.
nnoremap ,x *``cgn
nnoremap ,X #``cgN

" Clean up nbsp characters.
function! s:clean_nbsp()
    call setline('.', substitute(getline('.'), '\%xa0', ' ', 'g'))
endfunction
command! -range=% CleanNBSP :<line1>,<line2>call s:clean_nbsp()

" ----- Vim Scripts ----- {{{1

" ===== Toggle syntax ===== {{{2

" Initialize all highlights that have nothing to do with syntax.
function! s:Highlight_Init()
    highlight StatusLine gui=bold guifg=yellow guibg=#505050
    highlight StatusLineNC gui=NONE guifg=yellow guibg=#505050
    highlight User1 term=inverse cterm=inverse 
    highlight User1 gui=NONE guifg=green guibg=#505050
    highlight SignColumn ctermbg=black ctermfg=Cyan guibg=black guifg=Cyan
        
    " color customizations
    highlight Normal guifg=Gray guibg=black ctermfg=Gray ctermbg=black
    highlight Cursor ctermfg=black ctermbg=gray guifg=black guibg=gray
    highlight ModeMsg guifg=gray guibg=black ctermfg=gray ctermbg=black
    highlight MoreMsg guifg=LightGreen guibg=black ctermfg=LightGreen ctermbg=black
    highlight Question guifg=LightGreen guibg=black ctermfg=LightGreen ctermbg=black
    highlight Directory guifg=LightBlue guibg=black ctermfg=Cyan ctermbg=black
    highlight NonText guifg=Yellow guibg=black ctermfg=Yellow ctermbg=black
    highlight SpecialKey guifg=Magenta guibg=black ctermfg=Magenta ctermbg=black
    highlight CursorLine term=underline cterm=NONE ctermfg=white ctermbg=darkblue gui=NONE guifg=white guibg=blue
    highlight Visual term=reverse cterm=NONE ctermfg=black ctermbg=cyan gui=NONE guifg=black guibg=#32CED7
    highlight IncSearch term=reverse cterm=NONE ctermfg=black ctermbg=cyan gui=NONE guifg=black guibg=#32CED7
    highlight SpellCap term=reverse cterm=NONE ctermbg=darkblue gui=undercurl guisp=blue
    highlight SpellBad term=reverse cterm=NONE ctermbg=darkred gui=undercurl guisp=red

    if v:version >= 700
        highlight MatchParen guifg=Yellow guibg=DarkGreen ctermfg=Yellow ctermbg=DarkGreen

        " Popup menu colors.
        highlight PMenu ctermfg=White ctermbg=DarkBlue guifg=Gray guibg=#513692
        highlight PMenuSel ctermfg=White ctermbg=Brown guifg=Gray guibg=#824C21
        highlight PMenuSbar ctermfg=White ctermbg=Brown guifg=Gray guibg=#824C21
        highlight PMenuThumb ctermfg=Black ctermbg=Gray guifg=Black guibg=Gray
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

    highlight Comment guifg=orange ctermfg=Yellow
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
    if has('syntax_items')
        syntax off
    else
        call s:Turn_syntax_on()
        call s:Highlight_Init()
    endif
endfunction

" Define a :ToggleSyntax command.
command! ToggleSyntax :call <SID>Toggle_syntax()

" Start with syntax highlighting enabled.
call s:Turn_syntax_on()
call s:Highlight_Init()

" ===== Maximize/unmaximize vertically. ===== {{{2
function! <SID>Toggle_full_height()
    if exists('s:orig_height')
        execute 'set lines=' . s:orig_height
        unlet s:orig_height
    else
        let s:orig_height=&lines
        set lines=999
    endif
endfunction

" Define a :FullHeight command.
command! FullHeight :call <SID>Toggle_full_height()

" ===== Remove all buffers. ===== {{{2
function! <SID>Del_all_buf()
    let l:bufidx = 1
    while l:bufidx <= bufnr('$')
        if bufloaded(l:bufidx)
            execute 'bd' l:bufidx
        endif
        let l:bufidx = l:bufidx + 1
    endw
endfunction

" ===== Insert/update timestamp ===== {{{2
" Returns the current date in string form.
" The substitution gets rid of the leading 0 in the day of the month.
function! <SID>Date_string()
    return substitute(strftime('%B %d, %Y'), ' 0', ' ', '')
endfunction

" ===== Run ctags ===== {{{2
" Runs ctags in the current file's directory.
" Under win32, run ctags in the current directory because we can't
" reliably do a cd.
function! <SID>Run_ctags()
    let l:ctagsrun = 'ctags --if0 --totals --exclude=...* -n *.c *.cpp *.cc *.h'
    if has('win32')
        let l:ctagscmd = '!'.l:ctagsrun
    else
        let l:ctagscmd = '!cd '.expand('%:p:h').';'.l:ctagsrun
    endif
    execute l:ctagscmd
endfunction

" ===== Customize vim modes ===== {{{2
" Function for setting up vim buffer defaults.
" This will be overridden by settings for various programming languages if
" applicable.
function! <SID>Set_default_mode()
    " Rainbow Parentheses interferes with vault password hiding.
    " if &filetype != 'vault'
    "     RainbowParenthesesLoadBraces
    "     RainbowParenthesesLoadRound
    "     RainbowParenthesesLoadSquare
    " endif
endfunction

" Generic code setup for most languages.
function! s:Set_generic_code_mode()
    setlocal shiftwidth=2
    setlocal expandtab
    setlocal textwidth=78

    " q = Format comments with gq.
    " l = Don't break long lines in insert mode.
    " j = Remove comment leader when joining lines.
    setlocal formatoptions=qlj
endfunction

" Function for setting up vim for editing C source files.
function! s:Set_c_mode()
    call s:Set_generic_code_mode()

    setlocal cindent
    setlocal cinoptions=>s,:0,=s,hs,ps,t0,+s,(0,g0

    setlocal comments=://,b:#,:%,:XCOMM,n:>,fb:- 
    " Fancy comments.
    setlocal comments+=s1:/*,mb:*,elx:*/

    " do not re-indent if the user types in a colon.
    setlocal cinkeys=0{,0},0#,!^F,o,O,e
endfunction

" Function for setting up Vim to edit Ruby source files.
function! s:Set_ruby_mode()
    call s:Set_generic_code_mode()

    " Workaround needed because Perl ftplugin adds a colon to iskeyword globally.
    setlocal iskeyword-=:

    " Turn off balloon expr.
    setlocal noballooneval
    setlocal balloonexpr=
endfunction

" Function for setting up Vim to edit Vimscript source files.
function! s:Set_vimscript_mode()
    call s:Set_generic_code_mode()
    setlocal shiftwidth=4
endfunction

" Vim setup for editing text files.
function! s:Set_text_mode()
    setlocal nocindent
    setlocal nosmartindent

    setlocal shiftwidth=4
    setlocal expandtab
    setlocal textwidth=78

    " t = Autowrap text.
    " c = Autowrap comments.
    " q = Format comments with gq.
    " 2 = Use second line's indent to format rest of paragraph.
    setlocal formatoptions=tcq2

    " Break up inserts into smaller undo chunks.
    inoremap <buffer> . .<c-g>u
    inoremap <buffer> ? ?<c-g>u
    inoremap <buffer> ! !<c-g>u
    inoremap <buffer> , ,<c-g>u
    inoremap <buffer> ; ;<c-g>u
    inoremap <buffer> : :<c-g>u
endfunction

if has('autocmd')
    augroup vimrc_auto
        " Clear all auto-commands.
        autocmd!

        autocmd FileType *           call <SID>Set_default_mode()

        autocmd FileType java        call <SID>Set_generic_code_mode()
        autocmd FileType cs          call <SID>Set_generic_code_mode()
        autocmd FileType dosbatch,sh call <SID>Set_generic_code_mode()
        autocmd FileType php         call <SID>Set_generic_code_mode()
        autocmd FileType css,scss    call <SID>Set_generic_code_mode()
        autocmd FileType perl        call <SID>Set_generic_code_mode()
        autocmd FileType html        call <SID>Set_generic_code_mode()
        autocmd FileType javascript  call <SID>Set_generic_code_mode()
        autocmd FileType coffee      call <SID>Set_generic_code_mode()
        autocmd FileType clojure     call <SID>Set_generic_code_mode()
        autocmd FileType haskell     call <SID>Set_generic_code_mode()
        autocmd FileType conf        call <SID>Set_generic_code_mode()
        autocmd FileType thrift      call <SID>Set_generic_code_mode()

        autocmd FileType c,cpp      call <SID>Set_c_mode()
        autocmd FileType ruby,eruby call <SID>Set_ruby_mode()
        autocmd FileType vim        call <SID>Set_vimscript_mode()
        autocmd FileType d          call <SID>Set_vimscript_mode()
        autocmd FileType python     call <SID>Set_vimscript_mode()
        autocmd FileType json       call <SID>Set_vimscript_mode()
        autocmd FileType markdown   call <SID>Set_vimscript_mode()
        autocmd FileType text       call <SID>Set_text_mode()

        " Save crontab file in place. Otherwise crontab -e may think the file
        " has not changed.
        autocmd FileType crontab setlocal backupcopy=yes

        " Clear some artifacts in console Vim.
        autocmd VimEnter * redraw

        " autocmd BufRead,BufNewFile *.thrift setfiletype thrift
        " autocmd Syntax thrift source ~/.vim/thrift.vim

        " Override file type for .md since I'm not working on Modula-2
        " files.
        autocmd BufRead,BufNewFile *.md setlocal filetype=markdown

        " Use conf file type for monit files.
        autocmd BufRead,BufNewFile monitrc setlocal filetype=conf
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

" ===== Command-line completion ===== {{{2
"
" Based on:
" http://vim.sourceforge.net/scripts/script.php?script_id=474
" http://vim.sourceforge.net/scripts/script.php?script_id=147
"
" Adds the ability to word-complete in a regular (non-search) command-line
" and to word-complete in the middle of the command-line.

let s:lastcmdline = ''
let s:lastcmdpos = ''

function! <SID>CmdlineComplete()
    let l:cmdline = getcmdline()
    let l:cmdpos = getcmdpos()
    if l:cmdline == s:lastcmdline && l:cmdpos == s:lastcmdpos
        " User invoked completion again without moving cursor or editing
        let l:cmdline = s:origcmdline
        let l:cmdpos = s:origcmdpos
        let s:completeDepth = s:completeDepth . "\<C-N>"
    else
        " Starting new completion
        let s:origcmdline = l:cmdline
        let s:origcmdpos = l:cmdpos
        let s:completeDepth = "\<C-N>"
    endif

    " Set paste option to disable indent
    let l:paste = &l:paste
    setlocal paste

    let l:savecol = col('.')

    execute 'normal! o' . l:cmdline . "\<C-O>" . l:cmdpos . '|' . s:completeDepth

    " Update the command line and position.
    let s:lastcmdline = getline('.')
    let s:lastcmdpos = col('.') + 1

    " Check if we have come full circle and reset the search depth. This
    " needs to be done because Vim behaves in a weird way if too many
    " Ctrl-Ns are used in a macro.
    if s:lastcmdline == s:origcmdline
        let s:completeDepth = ''
    endif

    " Undo changes and restore cursor position
    execute 'normal! u' . l:savecol . '|'

    " Restore paste option
    let &l:paste = l:paste

    let l:tmp = setcmdpos(s:lastcmdpos)
    return s:lastcmdline
endfunction

" cnoremap <F12> <C-\>e<SID>CmdlineComplete()<cr>


" ===== Convert to decimal coordinates ===== {{{2
" For converting coordinates from N ddd mm.mmm W ddd mm.mmm to 
" dd.ddddd -dd.ddddd

function! <SID>ToDecimals(deg, minwhole, mindec)
    " Trim leading zeros so that the string won't be treated as octal.
    let l:deg = substitute(a:deg, '^0*', '', '')
    let l:minwhole = substitute(a:minwhole, '^0*', '', '')

    " Force the decimal portion of the minutes to be 3 decimal places.
    " And then trim leading zeros.
    let l:mindec = substitute(strpart(a:mindec.'000', 0, 3), '^0*', '', '')

    let l:val = (l:minwhole * 1000000 + l:mindec * 1000 + 30) / 60
    return l:deg . '.' . strpart('000000', 0, 6 - strlen(l:val)) . l:val
endfunction

function! <SID>ConvertCoords()
    let l:coord = '\(\d\+\)\D\+\(\d\+\)\D\+\(\d\+\)'
    let l:x = substitute(getline('.'), '\D*'.l:coord.'\D\+'.l:coord.'.*', '\=<SID>ToDecimals(submatch(1), submatch(2), submatch(3)) . "\<cr>-" . <SID>ToDecimals(submatch(4), submatch(5), submatch(6))', '')
    execute "normal o\<home>" . l:x . "\<esc>"
endfunction

" ------------------------------------------------------------------
" Convert geocaching URL followed by cache name into a HTML link.
"     function! Convert_gc_url()
"       s+^\([^ ]*?\)[^ ]*\(ID=\d\+\)[^ ]* \+\(.*\)$+<p><a href="\1pf=y\&\2\&log=y\&decrypt=y">\3</a>+e
"     endfunction

"     map ,c :call Convert_gc_url()<cr>
"     vmap ,c :call Convert_gc_url()<cr>
"     imap ,c <esc>:call Convert_gc_url()<cr>

" ===== Generate HTML geocache link ===== {{{2
" convert waypoint to ID number
" returns -1 if invalid waypoint
function! s:GCtoID(waypt)
    let l:waypt = toupper(a:waypt)
    let l:WPTCHARS = '0123456789ABCDEFGHJKMNPQRTVWXYZ'

    if match(l:waypt, '^GC[0-9A-F]\{1,4}$') >= 0
        return '0x' . strpart(l:waypt, 2) + 0
    " elseif match(waypt, '^GC[GHJ-KM-NP-RTV-Z][0-9A-HJ-KM-NP-RTV-Z]\{3}$') >= 0
    elseif match(l:waypt, '^GC[' . strpart(l:WPTCHARS, 16) . '][' . l:WPTCHARS . ']\{3}$') >= 0
        let l:accum = 0
        let l:i = 2
        while l:i < 6
            " echo waypt[i]
            let l:accum = l:accum * 31 + match(l:WPTCHARS, l:waypt[l:i])
            if l:i == 2
                let l:accum = l:accum - 16
            endif
            let l:i = l:i + 1
        endwhile
        return l:accum + 65536
    elseif match(l:waypt, '^GC[' . l:WPTCHARS . ']\{5}$') >= 0
        let l:accum = 0
        let l:i = 2
        while l:i < 7
            let l:accum = l:accum * 31 + match(l:WPTCHARS, l:waypt[l:i])
            if l:i == 2
                let l:accum = l:accum - 1
            endif
            let l:i = l:i + 1
        endwhile
        return l:accum + 512401
    else
        return -1
    endif
endfunction

" ,c Convert a line of the form
" waypt cache-title
" into a HTML geocache link.
function! <SID>ConvertGC()
    let l:gcregex = 'GC[0-9A-Za-z]\{1,5}'

    let l:fmt1 = '^\s*\d\+\.\s\+\(.*\)\s\+(.\{-})\s\+(\('.l:gcregex.'\))\s*$'
    let l:fmt2 = '^\s*\(.*\)\s\+by\s\+.\{-}\s\+(\('.l:gcregex.'\))\s*$'
    let l:fmt3 = '^\s*\('.l:gcregex.'\)\s\+\(.\{-}\)\s*$'

    let l:line = getline('.')
    let l:waypt = ''
    let l:title = ''

    let l:res = matchlist(l:line, l:fmt1)
    if l:res != []
        let l:waypt = l:res[2]
        let l:title = l:res[1]
    else
        let l:res = matchlist(l:line, l:fmt2)
        if l:res != []
            let l:waypt = l:res[2]
            let l:title = l:res[1]
        else
            let l:res = matchlist(l:line, l:fmt3)
            if l:res != []
                let l:waypt = l:res[1]
                let l:title = l:res[2]
            endif
        endif
    endif

    let l:title = substitute(l:title, '&', '\&amp;', 'g')
    let l:title = substitute(l:title, '<', '\&lt;', 'g')
    let l:title = substitute(l:title, '>', '\&gt;', 'g')

"    echo "waypt = ". waypt. ", title = ". title . "."

    let l:id = s:GCtoID(l:waypt)
    if l:id >= 0
        call setline('.', "<p><a href=\"http://www.geocaching.com/seek/cache_details.aspx?pf=y&ID=" . l:id . "&log=y&decrypt=y\">" . l:title . '</a>')
    endif
endfunction

nnoremap ,c :call <SID>ConvertGC()<cr>
vnoremap ,c :call <SID>ConvertGC()<cr>

" ===== Convert My Caches HTML to list of links. (new) ===== {{{2

" Get the content of the n'th element in a series of elements.
function! s:xml_get_nth(xmlstr, elem, n)
    let l:matchres = matchlist(a:xmlstr, '<'.a:elem.'\%( [^>]*\)\?>\(.\{-}\)</'.a:elem.'>', -1, a:n)
    return l:matchres == [] ? '' : l:matchres[1]
endfunction

" Remove leading and trailing whitespace.
function! s:trim_both(s)
    " Remove trailing whitespace.
    let l:s = substitute(a:s, '\s\+$', '', '')

    " Remove leading whitespace.
    return substitute(l:s, '^\s\+', '', '')
endfunction

" ,M Convert new-style my caches HTML to a list of links.
function! s:Convert_mycaches_3() range
    let l:m1 = 'http://www\.geocaching\.com/seek/cache_details\.aspx[^"]*'
    let l:m2 = '<a href="'.l:m1.'">\(.*\)</a>'

    let l:header = '<lj-cut text="The caches...">'."\<cr>".'<div style="margin: 10px 30px; border: 1px dashed; padding: 10px;">'."\<cr>"
    let l:footer = '</div>'."\<cr>".'</lj-cut>'."\<cr>"

    let l:outstr = ''
    let l:str = join(getline(a:firstline, a:lastline), '')

    " Remove ^M characters.
    let l:str = substitute(l:str, '\r', '', 'g')

    let l:trcount = 1
    while 1
        let l:logitem = s:xml_get_nth(l:str, 'tr', l:trcount)
        if l:logitem ==# ''
            break
        endif

        let l:linkitem = s:xml_get_nth(l:logitem, 'td', 3)

        " Get cache link.
        let l:linkstr = matchstr(l:linkitem, l:m1, 0)
        if l:linkstr !=# ''

            " Get cache name.
            let l:matchres = matchlist(l:linkitem, l:m2)
            let l:name = s:trim_both(l:matchres[1])

            let l:state = s:trim_both(s:xml_get_nth(l:logitem, 'td', 4))
            
            let l:link = '<a href="'.l:linkstr.'">'.l:name.' ('.l:state.")</a>\r"

            " Prepend to reverse the order of the log items.
            let l:outstr = l:link . l:outstr
        endif

        let l:trcount += 1
    endwhile

    " Pick the correct change command so that autoindent is not in effect.
    " We want the inserted lines to have no indent.
    let l:changecmd = &autoindent ? 'change!' : 'change'
    silent execute 'normal :' . a:firstline . ',' . a:lastline . l:changecmd . "\<cr>" . l:header . l:outstr . l:footer . "\<esc>"
endfunction

vnoremap ,M :call <SID>Convert_mycaches_3()<cr>

" ===== Convert text to HTML ===== {{{2
" Convert text to HTML by escaping <, >, ", and &.
function! <SID>HtmlizeText()
    let l:line = getline('.')
    let l:line = substitute(l:line, '&', '\&amp;', 'g')
    let l:line = substitute(l:line, '<', '\&lt;', 'g')
    let l:line = substitute(l:line, '>', '\&gt;', 'g')
    let l:line = substitute(l:line, '"', '\&quot;', 'g')
    call setline('.', l:line)
endfunction

nnoremap ,h :call <SID>HtmlizeText()<cr>
vnoremap ,h :call <SID>HtmlizeText()<cr>

" ===== Convert Topozone URL to Geobloggers tags for Flickr. ===== {{{2
function! <SID>ConvertGeoTag()
    let l:coords = '.\{-}\(\d\+\.\d\+\).\{-}\(-\d\+\.\d\+\).*'
    let l:x = substitute(getline('.'), l:coords, 'geotagged geo:lat=\1 geo:lon=\2', '')
    execute 'normal o' . l:x . "\<cr><a href=\"http://www.geobloggers.com\">geotagged</a>\<esc>"
endfunction

nnoremap ,f :call <SID>ConvertGeoTag()<cr>
vnoremap ,f <esc>:call <SID>ConvertGeoTag()<cr>gv

" ===== Add LJ user tag around the current word. ===== {{{2
nnoremap ,u ciw<lj user="<c-r>""><esc>
vnoremap ,u c<lj user="<c-r>""><esc>

nnoremap ,U ciw<lj comm="<c-r>""><esc>
vnoremap ,U c<lj comm="<c-r>""><esc>

" Update for Dreamwidth. Use this for both users and communities.
nnoremap ,u ciw<user name="<c-r>"" site="livejournal.com"><esc>
vnoremap ,u c<user name="<c-r>"" site="livejournal.com"><esc>

" ===== Toggle between name and name=aname in nuvigc shell script. ===== {{{2
function! s:equal_toggle_2(str) abort
    return join(map(split(a:str), stridx(a:str, '=') < 0 ? 'v:val."=a".v:val' : 'split(v:val, "=")[0]'))
endfunction

function! s:equal_toggle(lineno) abort
    call setline(a:lineno, substitute(getline(a:lineno), '(\(.*\))', '\="(".s:equal_toggle_2(submatch(1)).")"', ''))
endfunction

function! s:do_equal_toggle(type) abort
    for l:lnum in range(line("'["), line("']"))
        call s:equal_toggle(l:lnum)
    endfor
endfunction

nnoremap <F12>== :call <SID>equal_toggle('.')<cr>
vnoremap <F12>= :call <SID>equal_toggle('.')<cr>
nnoremap <F12>= :set operatorfunc=<SID>do_equal_toggle<cr>g@

" ===== Use the Silver Searcher for searching, if available ===== {{{2
" Borrowed from: http://robots.thoughtbot.com/faster-grepping-in-vim/

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " Don't use this if we have the ag plugin.
  " command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
endif

" }}}1
" ----- Local vimrc ----- {{{1

" Source a local vimrc file if one exists. This is useful for
" customizations that differ from system to system.
if $HOME !=# '' && filereadable($HOME.'/vimrc.local')
    execute 'source '.$HOME.'/vimrc.local'
elseif $VIM !=# '' && filereadable($VIM.'/vimrc.local')
    execute 'source '.$VIM.'/vimrc.local'
endif

" }}}1

" ----- coc.nvim customizations -----
" From https://github.com/neoclide/coc.nvim/blob/master/Readme.md

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "<C-n>" :
      \ <SID>check_back_space() ? "<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "<C-p>" : "<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "<C-y>" : "<C-g>u<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Last updated: August 7, 2019
