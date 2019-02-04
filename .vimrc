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

" path settings

function! IncludePath(path)
  if has('win16') || has('win32') || has('win64')
    let delimiter = ";"
  else
    let delimiter = ":"
  endif
  let pathlist = split($PATH, delimiter)
  if isdirectory(a:path) && index(pathlist, a:path) == -1
    let $PATH=a:path.delimiter.$PATH
  endif
endfunction

" python
call IncludePath(expand('~/.pyenv/shims'))
set pyxversion=3
let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'

" golang
set runtimepath+=$HOME/go/src/github.com/golang/lint/misc/vim

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
  call dein#add('vim-syntastic/syntastic')
  call dein#add('davidhalter/jedi-vim')
  call dein#add('lambdalisue/vim-pyenv')
  call dein#add('fatih/vim-go')
  call dein#add('elzr/vim-json')
  call dein#add('kylef/apiblueprint.vim')
  call dein#add('plasticboy/vim-markdown')
  call dein#add('chrisbra/Colorizer')

  " call dein#add('Shougo/deoplete.nvim')
  " call dein#add('zchee/deoplete-go', {'build': 'make'})

  " if !has('nvim')
  "   call dein#add('roxma/nvim-yarp')
  "   call dein#add('roxma/vim-hug-neovim-rpc')
  " endif

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

" syntastic
let g:syntastic_python_checkers = ['pyflakes', 'pep8']
let g:syntastic_go_checkers = ['go', 'golint', 'govet']

" jedi-vim
autocmd FileType python setlocal completeopt-=preview

" deoplete
let g:deoplete#enable_at_startup = 1

" vim-go
let g:go_gocode_unimported_packages = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

let g:go_fmt_command = "goimports"

colorscheme jellybeans
