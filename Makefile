CONFIG_DIR = $(HOME)/.config
DOTFILES_DIR = $(HOME)/dotfiles

BREW_CMD = /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

system-dependencies:
	@which brew >/dev/null 2>&1 || $(BREW_CMD)  # Install Homebrew only if not installed
	@brew install fzf
	@brew install reattach-to-user-namespace
	@brew install blueutil


brew-dependencies:
	@brew install neovim
	@brew install tmux
	@brew install ghostty
	@brew install rectangle
	@brew install helix
	@brew install yazi
	@brew install uv
	@brew install git-delta


link:
	@for name in nvim tmux zsh ghostty helix; do \
		src="$(DOTFILES_DIR)/$$name"; \
		dst="$(CONFIG_DIR)/$$name"; \
		[ ! -e $$dst ] && ln -s $$src $$dst || echo "$$dst already exists"; \
	done

	@for name in git/.gitconfig zsh/.zshrc; do \
		base=$${name##*/}; \
		src="$(DOTFILES_DIR)/$$name"; \
		dst="$(HOME)/$$base"; \
		[ ! -e $$dst ] && ln -s $$src $$dst || echo "$$dst already exists"; \
	done

python-dependencies:
	@uv python install
	@pip install -U 'python-lsp-server[all]'

all: system-dependencies brew-dependencies link python-dependencies
