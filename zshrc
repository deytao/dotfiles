CASE_SENSITIVE=true
ZSH_DISABLE_COMPFIX=true

ANTIGEN_PATH=$HOME/dotfiles
source $ANTIGEN_PATH/antigen/antigen.zsh
antigen init ${HOME}/.antigenrc

plugins=()

export LANG=en_US.UTF-8
export LANGUAGE=en_US:en_GB:en
export TERM='screen-256color'
export LC_ALL=en_US.utf-8
export LC_CTYPE=en_US.utf-8
export EDITOR=nvim
export PGHOST=localhost
export GPG_TTY=$(tty)

# Customize to your needs...
alias less='less -r'
alias vi='nvim'
alias tmux='tmux -2'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='
  --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229
  --color info:150,prompt:110,spinner:150,pointer:167,marker:174
'

if [ -f ~/.localrc ]
then
    source ~/.localrc
fi

PYTHONSTARTUP=~/.pythonrc.py
export PYTHONSTARTUP

export PYENV_VERSION=3.11.4
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias fixssh='eval $(tmux showenv -s SSH_AUTH_SOCK)'
. "/home/deytao/.acme.sh/acme.sh.env"
