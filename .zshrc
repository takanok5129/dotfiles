# Created by newuser for 5.4.2
eval $(/usr/libexec/path_helper -s)

export EDITOR=vim
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export KCODE=u

bindkey -v
bindkey "^?" backward-delete-char

setopt no_beep
setopt auto_cd
setopt notify

fpath=(/usr/local/share/zsh-completions $fpath)

autoload -U compinit
compinit
#autoload -U compinit; compinit
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTTIMEFORMAT='%F %T '
setopt bang_hist
setopt extended_history
setopt hist_ignore_dups
setopt share_history
setopt append_history
setopt hist_reduce_blanks

export CLICOLOR=true

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
  local left=' %{\e[38;5;2m%}(%~)%{\e[m%}'
  vcs_info
  local right="%{\e[38;5;32m%}${vcs_info_msg_0_}%{\e[m%}"
  local invisible='%([BSUbfksu]|([FK]|){*})'
  local leftwidth=${#${(S%%)left//$~invisible/}}
  local rightwidth=${#${(S%%)right//$~invisible/}}
  local padwidth=$(($COLUMNS - ($leftwidth + $rightwidth) % $COLUMNS))

  print -P $left${(r:$padwidth:: :)}$right
}

autoload -U colors; colors

# 通常
tmp_prompt="%{${bg[green]}%}%n%{${reset_color}%} $ "
tmp_prompt2="%{${fg[white]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

# root
if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

PROMPT=$tmp_prompt
PROMPT2=$tmp_prompt2
SPROMPT=$tmp_sprompt

RPROMPT=$'%{\e[38;5;251m%}%D{%b%/%d}, %*%{\e[m%}'

# auto-fu.zsh
#source $HOME/.zsh/auto-fu.zsh/auto-fu.zsh
#function zle-line-init(){
#    auto-fu-init
#}
#zle -N zle-line-init
#zstyle ':auto-fu:var' postdisplay $''

# short commands
alias l='ls'
alias la='ls -a'
alias ll='ls -la'

alias h='history'
alias a='./a.out'

# rbenv
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# neovim
alias vim="nvim"
export NVIM_PYTHON_LOG_FILE="/tmp/nvim-python-log"

# nodebrew
if [ -d "$HOME/.nodebrew" ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

# mysqlenv
# source ~/.mysqlenv/etc/bashrc
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# golang
export GOPATH=$HOME/go
export PATH=$HOME/go/bin:$PATH
export GO111MODULE=on

# goenv
if [ -d "$HOME/.goenv" ]; then
  export GOENV_DISABLE_GOPATH="1"
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

# rust
if [ -d "$HOME/.cargo" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# imagemagick
export PKG_CONFIG_PATH=/opt/ImageMagick/lib/pkgconfig

# texinfo
if [ -d "/usr/local/opt/texinfo" ]; then
  export PATH="/usr/local/opt/texinfo/bin:$PATH"
fi

# .zshrc.local for local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
