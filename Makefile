CONFIG_DIR = $(HOME)/.config
DOTFILES_DIR = $(HOME)/dotfiles

BREW_CMD = /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

install-dependencies:
	@which brew >/dev/null 2>&1 || $(BREW_CMD)  # Install Homebrew only if not installed
	@brew install fzf
	@brew install reattach-to-user-namespace
	@brew install blueutil

install:
	@brew install neovim
	@brew install tmux
	@brew install ghostty
	@brew install rectangle

link:
	@for name in nvim tmux zsh ghostty; do \
		src="$(DOTFILES_DIR)/$$name"; \
		dst="$(CONFIG_DIR)/$$name"; \
		[ ! -e $$dst ] && ln -s $$src $$dst || echo "$$dst already exists"; \
	done

	@src="$(DOTFILES_DIR)/zsh/.zshrc"; dst="$(HOME)/.zshrc"; \
	[ ! -e $$dst ] && ln -s $$src $$dst || echo "$$dst already exists"

all: install-dependencies install link
