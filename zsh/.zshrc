ZSH_THEME="robbyrussell"

plugins=(git)

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim

export PATH="$HOME/dotfiles/bin:$PATH"
export MYVIMRC="$HOME/.config/init.lua"
export PATH="$PATH:$HOME/dotfiles/bin/"

export DOTFILES="$HOME/dotfiles"
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
source $DOTFILES/zsh/utils.zsh --source_only
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Cursor thing
export XDG_DATA_DIRS=/usr/share:/usr/local/share
function cursor {
    (nohup /opt/cursor.appimage "$@" > /dev/null 2>&1 &)
}
source $HOME/.local/bin

. $HOME/.asdf/plugins/golang/set-env.zsh
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

fzfp() {
    local dir
    dir=$(find $HOME/personal_files  -type d | fzf)
    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}
fzfc() {
    local dir
    dir=$(find $HOME/code -type d | fzf)
    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}
