# Created by newuser for 5.4.2
eval $(/usr/libexec/path_helper -s)

export EDITOR=nvim
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

bindkey -v
bindkey "^?" backward-delete-char

setopt no_beep
setopt auto_cd
setopt notify

if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  autoload -Uz compinit
  compinit

  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi

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
alias evimdiff='nvim -d "$(mktemp)" "$(mktemp)"'
export NVIM_PYTHON_LOG_FILE="/tmp/nvim-python-log"

# vscode
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# mysql
if [ -d "/usr/local/opt/mysql@5.7" ]; then
  export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/mysql@8.0" ]; then
  export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
fi

# golang
export GOPATH=$HOME/go
export GO111MODULE=on

# goenv
if [ -d "$HOME/.goenv" ]; then
  export GOENV_DISABLE_GOPATH="1"
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  #export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
  export PATH="$GOENV_ROOT/shims:$PATH"
fi

# plenv
if [ -d "$HOME/.plenv" ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
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

# pipx
export PATH="$PATH:$HOME/.local/bin"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# .zshrc.local for local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
