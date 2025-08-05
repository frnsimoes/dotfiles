ZSH_THEME="robbyrussell"

plugins=(git)

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=hx


export PATH="$HOME/dotfiles/bin:$PATH"
export MYVIMRC="$HOME/.config/init.lua"
export PATH="$PATH:$HOME/dotfiles/bin/"
export PATH="$PATH:$HOME/bin/"
export PATH="$PATH:$HOME/work/bin/"

export DOTFILES="$HOME/dotfiles"
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


gt() {
    selected_dir=$(find . -type d -not -path '*/.*' 2>/dev/null | fzf --height=40% --border --preview 'ls -la {}')
    if [ -n "$selected_dir" ]; then
        cd "$selected_dir"
        echo "Moved to: $selected_dir"
    else
        echo "No directory selected"
    fi
}
