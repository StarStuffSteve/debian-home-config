export ZSH="/root/.oh-my-zsh"

ZSH_THEME="kphoen"

DISABLE_AUTO_UPDATE="true"

DISABLE_AUTO_TITLE="true"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

export PATH=~/.local/bin:$PATH
