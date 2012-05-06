" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.
set nocompatible
"Calling pathogen
call pathogen#infect()

colorscheme dc2
syntax on
set t_Co=256
set number
set cursorline
"The VIM software has had several remote vulnerabilities
"discovered within VIM's modeline support.
set nomodeline

"indentation
if has("autocmd")
    filetype plugin indent on
endif
"set cindent
"how many spaces we want for tabs
set tabstop=4
"amount of whitespace to insert using
"indent commands in normal mode
set shiftwidth=4
set softtabstop=4
"replace tabs for spaces
set expandtab

"allows you to switch from an unsaved buffer without saving it first
set hidden

"completition
set ofu=syntaxcomplete#Complete

"templates
autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e

"binds
inoremap <F1> <C-O>b
nnoremap <F1> b
inoremap <F2> <C-O>w
nnoremap <F2> w
nnoremap <F3> :set hlsearch! hlsearch?<CR>
nnoremap <F9> <C-^>

"mapleader
let mapleader = "`"
map <leader>1 "+y
map <leader>2 "+p
nmap <leader>l :set list!<CR>
nmap <leader>n :NERDTreeToggle<CR>

"invisible chars
set listchars=tab:▸\ ,eol:¬
highlight NonText ctermfg=237
highlight SpecialKey ctermfg=233

"gist settings
let g:gist_detect_filetype = 1
let g:gist_show_privates   = 1
let g:gist_post_private    = 1

"NERDtree settings
let g:NERDTreeChDirMode = 2
let g:NERDTreeIgnore    = ['\~$', '\.swp$', '\.o$', '\.hi$']
let g:NERDTreeMinimalUI = 1
