CONFIG_DIR = $(HOME)/.config
DOTFILES_DIR = $(HOME)/dotfiles
BREW_CMD = /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

install-brew:
	$(BREW_CMD)

install-fzf:
	brew install fzf

install-namespace:
	brew install reattach-to-user-namespace

install-blueutil:
	brew install blueutil

install-all: install-brew install-fzf install-namespace install-blueutil

link-nvim:
	mkdir -p $(CONFIG_DIR)/nvim
	ln -sf $(DOTFILES_DIR)/nvim/* $(CONFIG_DIR)/nvim/

link-tmux:
	mkdir -p $(CONFIG_DIR)/tmux
	ln -sf $(DOTFILES_DIR)/tmux/* $(CONFIG_DIR)/tmux/

link-zsh:
	mkdir -p $(CONFIG_DIR)/zsh
	ln -sf $(DOTFILES_DIR)/zsh/* $(CONFIG_DIR)/zsh/

link-zshrc:
	ln -sf $(DOTFILES_DIR)/zsh/.zshrc $(HOME)/.zshrc

# Group all tasks
link-all: link-nvim link-tmux link-zsh link-zshrc


ssh-tk:
	ssh frns@192.168.1.222 
