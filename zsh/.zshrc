ZSH_THEME="robbyrussell"

plugins=(git)

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim


export PATH="$HOME/workspace/dotfiles/bin:$PATH"
export MYVIMRC="$HOME/.config/init.lua"
export PATH="$PATH:$HOME/workspace/dotfiles/bin/"
export PATH="$PATH:$HOME/bin/"
export PATH="$PATH:$HOME/work/bin/"

export DOTFILES="$HOME/workspace/dotfiles"
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

# zoxide
autoload -Uz compinit
compinit
eval "$(zoxide init zsh)"

# asdf
source /opt/homebrew/opt/asdf/libexec/asdf.sh
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
. ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh

for file in ~/workspace/dotfiles/zsh/*.zsh; do
  source "$file"
done

for file in ~/workspace/dotfiles/scripts/*.sh; do
    source "$file"
done

alias chp='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --profile-directory="Profile 2"'
alias chg='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --profile-directory="Profile 6"'

export PATH="$(go env GOPATH)/bin:$PATH"

export AWS_PROFILE=tintim

alias vim=nvim
export PATH="$HOME/.local/bin:$PATH"


alias tmux-restart='tmux kill-server && tmux'
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"
source /Users/fernandosimoes/.zsh_kraft_completion;
