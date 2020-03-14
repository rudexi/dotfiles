syntax enable
set background=dark
colorscheme solarized8_dark
set number
set cursorline
set encoding=utf-8
set ff=unix " Remove \r automatically
" filetype indent on

" viminfo buffer
set viminfo='100,<1000

" Pathogen
execute pathogen#infect()

" Toogle solarized
call togglebg#map("<F4>")

" let b:syntastic_python_python_exec = '/usr/bin/python3'

"
set laststatus=2
set noshowmode
let g:lightline = {'colorscheme': 'solarized'}


" See tabs
set list
set listchars=tab:\ \ ,nbsp:.

" 1 tab = 4 spaces
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent

" Indent of 2 for yaml, html, xml
au FileType html,xml,ruby,xml.erb,ruby.erb,html.erb,eruby,tld,json,vim,vue,javascript,bash,sh
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set autoindent

" au BufWinEnter,BufRead,BufNewFile *.pp set filetype=puppet
" au BufWinEnter,BufRead,BufNewFile *.j2 set filetype=jinja

" Wrapping
set wrap
" set breakindent " keep the indent
" set showbreak=.. " show the line wrapping
" set lbr " soft wrap (words rather than char)


" Red strailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" 80 char limit
" highlight OverLenght ctermbg=red
" match OverLength /\%>80v.\+/

" Folding functions with space
" set foldmethod=indent
" set foldlevel=99
" nnoremap <space> za
set nofoldenable " disable folding

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
" Checkers
let g:syntastic_yaml_checkers = ['yamllint']
" au BufRead *.py
"    \ let:b:syntastic_python_python_exec = syntastic#util#parseShebang()['exe'] ==# 'python3' ? 'python3' : 'python'

" Status line

"set statusline=
"set statusline+=%h%m%r%w        " flag
"set statusline+=%t          " path

"set statusline+=%=              " right align
"set statusline+=%10((%l,%c)%)  " line, column
"set statusline+=%P              " percentage

" Multiple highlighting

function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
    let ft=toupper(a:filetype)
    let group='textGroup'.ft
    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif
    execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
    try
        execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax=s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.ft.'
        \ matchgroup='.a:textSnipHl.'
        \ start="'.a:start.'" end="'.a:end.'"
        \ contains=@'.group
endfunction

" Mouse support
" set mouse=a
