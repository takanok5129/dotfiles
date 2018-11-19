# Created by newuser for 5.4.2
eval $(/usr/libexec/path_helper -s)

export EDITOR=vim
export LANG=ja_JP.UTF-8
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
HISTSIZE=10000
SAVEHIST=10000
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
source $HOME/.zsh/auto-fu.zsh/auto-fu.zsh
function zle-line-init(){
    auto-fu-init
}
zle -N zle-line-init
zstyle ':auto-fu:var' postdisplay $''


# short commands
alias l='ls'
alias la='ls -a'
alias ll='ls -la'

alias h='history'
alias a='./a.out'

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH=$HOME/.nodebrew/current/bin:$PATH

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# mysqlenv
# source ~/.mysqlenv/etc/bashrc
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
