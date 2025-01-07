ZSH_THEME="robbyrussell"

plugins=(git)

export LANG=en_US
export LANGUAGE=en
export LC_MESSAGES=C

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=hx

source /opt/homebrew/opt/asdf/libexec/asdf.sh

export PATH="$HOME/dotfiles/bin:$PATH"
export MYVIMRC="$HOME/.config/init.lua"
export PATH="$PATH:$HOME/dotfiles/bin/"

export DOTFILES="$HOME/dotfiles"
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
source $DOTFILES/zsh/utils.zsh --source_only

. "$HOME/.local/bin/env"
