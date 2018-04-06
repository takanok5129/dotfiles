scriptencoding utf-8
set encoding=utf-8
set ambw=double

set smarttab
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=0
set shiftround
set infercase
set laststatus=2
set ruler
set number
set list
"set cursorline
set hidden
set backspace=indent,eol,start
set autoindent
set nowrap
set formatoptions-=r
set formatoptions-=o
set fileformats=unix,dos,mac
set showmatch
set notitle
set ignorecase
set smartcase
set hlsearch
set incsearch
set wrapscan

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/')
  call dein#begin('$HOME/')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/repos/github.com/Shougo/dein.vim')

  call dein#add('itchyny/lightline.vim')
  call dein#add('osyo-manga/vim-anzu')
  call dein#add('nanotech/jellybeans.vim')
  call dein#add('scrooloose/syntastic')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \  'left': [
      \    ['mode', 'paste'],
      \    ['fugitive', 'gitgutter', 'readonly', 'filename', 'modified', 'anzu']
      \  ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"x":""}',
      \ },
      \ 'component_function': {
      \   'anzu': 'anzu#search_status',
      \   'fugitive': 'MyFugitive',
      \   'gitgutter': 'MyGitGutter'
      \ },
      \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
      \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
      \ }

colorscheme jellybeans
