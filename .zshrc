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

# homebrew's path set to /opt/homebrew/bin/brew (in M1 mac) or /usr/local/bin/brew (in Intel mac)
if [ -f /opt/homebrew/bin/brew ]; then
  local HOMEBREW_BIN="/opt/homebrew/bin/brew"
else
  local HOMEBREW_BIN="/usr/local/bin/brew"
fi

if type ${HOMEBREW_BIN} &>/dev/null; then
  HOMEBREW_PREFIX=$(${HOMEBREW_BIN} --prefix)
  FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH

  # Load zsh-autosuggestions if available
  if [ -f $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi

  # Load zsh-syntax-highlighting if available
  if [ -f $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi

  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi

# Enable completion system
autoload -Uz compinit
compinit

# AWS CLI completion
local aws_completer_path="/usr/local/bin/aws_completer"
if [ -f "${aws_completer_path}" ]; then
  # Enable bash-style completion for AWS CLI
  autoload -Uz bashcompinit
  bashcompinit

  complete -C "${aws_completer_path}" aws
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

autoload -U colors
colors

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
if [ -d "$HOME/.volta" ]; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# mysql
if [ -n "$HOMEBREW_PREFIX" ]; then
  if [ -d "$HOMEBREW_PREFIX/opt/mysql@5.7" ]; then
    export PATH="$HOMEBREW_PREFIX/opt/mysql@5.7/bin:$PATH"
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/mysql@8.0" ]; then
    export PATH="$HOMEBREW_PREFIX/opt/mysql@8.0/bin:$PATH"
  fi
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
if [ -d "/opt/ImageMagick" ]; then
  export PKG_CONFIG_PATH=/opt/ImageMagick/lib/pkgconfig
fi

# texinfo
if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/texinfo" ]; then
  export PATH="$HOMEBREW_PREFIX/opt/texinfo/bin:$PATH"
fi

# pipx
export PATH="$PATH:$HOME/.local/bin"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# .zshrc.local for local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
