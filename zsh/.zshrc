ZSH_THEME="robbyrussell"

plugins=(git)

source /opt/homebrew/opt/asdf/libexec/asdf.sh

export PATH="$HOME/bin:$PATH"
export MYVIMRC="$HOME/.config/init.lua"
export PATH="$PATH:$HOME/dotfiles/bin/"

export DOTFILES="$HOME/dotfiles"
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
source $DOTFILES/zsh/utils.zsh --source_only
source $DOTFILES/zsh/init.zsh --source_only

init
