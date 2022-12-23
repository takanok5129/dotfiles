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
set cursorline
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
set splitright
set nofoldenable

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
call IncludePath(expand('$HOME/.pyenv/shims'))
let g:python_host_prog = $PYENV_ROOT . '/shims/python2'
let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'
let g:pyenv#auto_activate = 0

" golang
set runtimepath+=$HOME/go/src/golang.org/x/lint/misc/vim

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Set Dein base path (required)
let s:dein_base = '$HOME/.cache/dein'

" Set Dein source path (required)
let s:dein_src = '$HOME/.cache/dein/repos/github.com/Shougo/dein.vim'

" Set Dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" Required:
if dein#load_state(s:dein_base)
  call dein#begin(s:dein_base)

  " Let dein manage dein
  " Required:
  call dein#add(s:dein_src)

  call dein#add('lambdalisue/vim-pyenv')
  call dein#add('Shougo/denite.nvim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('osyo-manga/vim-anzu')
  call dein#add('nanotech/jellybeans.vim')
  call dein#add('Lokaltog/vim-easymotion')
  call dein#add('vim-syntastic/syntastic')
  call dein#add('Vimjas/vim-python-pep8-indent')
  call dein#add('davidhalter/jedi-vim')
  call dein#add('zchee/deoplete-jedi')
  call dein#add('zchee/deoplete-go', {'build': 'make'})
  call dein#add('fatih/vim-go')
  call dein#add('elzr/vim-json')
  call dein#add('kylef/apiblueprint.vim')
  call dein#add('plasticboy/vim-markdown')
  call dein#add('chrisbra/Colorizer')
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  call dein#add('thinca/vim-quickrun')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')
  call dein#add('udalov/kotlin-vim')
  call dein#add('keith/swift.vim')

  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

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

autocmd BufNewFile,BufRead *.tera setlocal ft=html

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
if jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif

" deoplete
let g:deoplete#enable_at_startup = 1

" vim-anzu
" mapping
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
" statusline
set statusline=%{anzu#search_status()}

" vim-easymotion
let g:EasyMotion_leader_key=";"

" vim-go
let g:go_gocode_unimported_packages = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

let g:go_fmt_command = "goimports"

" quickrun
let g:quickrun_config = {
      \  "_": {
      \     "runner": "vimproc",
      \     "runner/vimproc/updatetime" : 60,
      \     "hook/time/enable" : 1,
      \     "hook/time/dest": "buffer",
      \     "outputter/error/success": "buffer",
      \     "outputter/buffer/split": ":botright 4sp",
      \     "outputter/buffer/close_on_empty": 1,
      \  },
      \  "python": {
      \     "command": "$PYENV_ROOT/shims/python3",
      \  },
      \  "go": {
      \     "outputter/buffer/split": "vertical",
      \  },
      \ }
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_scessions() : "\<C-c>"
nnoremap <silent><F5> :QuickRun -mode n<CR>
vnoremap <silent><F5> :QuickRun -mode v<CR>

colorscheme jellybeans
