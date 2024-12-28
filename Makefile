CONFIG_DIR = $(HOME)/.config
DOTFILES_DIR = $(HOME)/dotfiles
BREW_CMD = /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

install:
	$(BREW_CMD)
	brew install fzf
	brew install reattach-to-user-namespace
	brew install blueutil

link:
	@[ ! -e $(CONFIG_DIR)/nvim ] && ln -s $(DOTFILES_DIR)/nvim $(CONFIG_DIR)/nvim || echo "$(CONFIG_DIR)/nvim already exists"
	@[ ! -e $(CONFIG_DIR)/tmux ] && ln -s $(DOTFILES_DIR)/tmux $(CONFIG_DIR)/tmux || echo "$(CONFIG_DIR)/tmux already exists"
	@[ ! -e $(CONFIG_DIR)/zsh ] && ln -s $(DOTFILES_DIR)/zsh $(CONFIG_DIR)/zsh || echo "$(CONFIG_DIR)/zsh already exists"
	@[ ! -e $(HOME)/.zshrc ] && ln -s $(DOTFILES_DIR)/zsh/.zshrc $(HOME)/.zshrc || echo "$(HOME)/.zshrc already exists"
	@[ ! -e $(CONFIG_DIR)/ghostty ] && ln -s $(DOTFILES_DIR)/ghostty $(CONFIG_DIR)/ghostty || echo "$(CONFIG_DIR)/ghostty already exists"


fresh-start:
	install link
