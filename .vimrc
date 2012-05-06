"set nocompatible
" .vimrc
" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.
"		 set textwidth=80 color: peachpuff

colorscheme dc2
syntax on
filetype plugin indent on
set t_Co=256
set number
set cursorline
"The VIM software has had several remote vulnerabilities
"discovered within VIM's modeline support.
set nomodeline

"indentation
"set cindent
set tabstop=4
set shiftwidth=4
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
map <F10> :NERDTreeToggle<CR>

"mapleader
let mapleader = "`"
map <leader>1 "+y
map <leader>2 "+p

"Calling pathogen
call pathogen#infect()

"gist settings
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1
