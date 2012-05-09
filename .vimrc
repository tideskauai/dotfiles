" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.
set nocompatible
"Calling pathogen
call pathogen#infect()

colorscheme dc2
syntax on
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

"keep attributes of original file
set backupcopy=yes
"store backups under ~/.vim/backup
set backupdir=$HOME/.vim/backup
"keep swaps under ~/.vim/swap
set directory=~/.vim/swap

" Code folding
"--------------------------
if has ('folding')
  set foldenable
  set foldmethod=marker
  set foldmarker={{{,}}}
  set foldcolumn=0
endif

" Mail
"--------------------------
autocmd FileType mail,human set formatoptions+=t textwidth=72
" Python stuff
"--------------------------
autocmd FileType python let python_highlight_all = 1
autocmd FileType python let python_slow_sync = 1
autocmd FileType python set expandtab shiftwidth=4 softtabstop=4
autocmd FileType python set completeopt=preview

" Binds
"--------------------------
inoremap <F1> <C-O>b
nnoremap <F1> b
inoremap <F2> <C-O>w
nnoremap <F2> w
nnoremap <F5> :set hlsearch! hlsearch?<CR>
nnoremap <F9> <C-^>

" Mapleader
"--------------------------
let mapleader = "`"
map <leader>1 "+y
map <leader>2 "+p
nmap <leader>l :set list!<CR>
nmap <leader>n :NERDTreeToggle<CR>

" Invisible chars
"--------------------------
set listchars=tab:→\ ,trail:·\,eol:¬
highlight NonText ctermfg=237
highlight SpecialKey ctermfg=234

" Gist settings
"--------------------------
let g:gist_detect_filetype = 1
let g:gist_show_privates   = 1
let g:gist_post_private    = 1

" NERDtree settings
"--------------------------
let g:NERDTreeChDirMode = 2
let g:NERDTreeIgnore    = ['\~$', '\.swp$', '\.o$', '\.hi$']
let g:NERDTreeMinimalUI = 1

" Ultisnip settings
"--------------------------
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories  = ["my_snippets"]
