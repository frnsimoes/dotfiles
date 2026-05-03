CLAUDE_DIR := $(HOME)/.claude
SKILLS_SRC := $(CURDIR)/skills
SKILLS_DST := $(CLAUDE_DIR)/skills
COMMANDS_SRC := $(CURDIR)/commands
COMMANDS_DST := $(CLAUDE_DIR)/commands

.PHONY: install link link-skills link-commands unlink unlink-skills unlink-commands status

install: link

link: link-skills link-commands

link-skills:
	@mkdir -p $(CLAUDE_DIR)
	@if [ -e $(SKILLS_DST) ] && [ ! -L $(SKILLS_DST) ]; then \
		echo "ERROR: $(SKILLS_DST) exists and is not a symlink."; \
		echo "Move or remove it first, then re-run 'make link-skills'."; \
		exit 1; \
	fi
	@ln -sfn $(SKILLS_SRC) $(SKILLS_DST)
	@echo "Linked $(SKILLS_DST) -> $(SKILLS_SRC)"

link-commands:
	@mkdir -p $(CLAUDE_DIR)
	@if [ -e $(COMMANDS_DST) ] && [ ! -L $(COMMANDS_DST) ]; then \
		echo "ERROR: $(COMMANDS_DST) exists and is not a symlink."; \
		echo "Move or remove it first, then re-run 'make link-commands'."; \
		exit 1; \
	fi
	@ln -sfn $(COMMANDS_SRC) $(COMMANDS_DST)
	@echo "Linked $(COMMANDS_DST) -> $(COMMANDS_SRC)"

unlink: unlink-skills unlink-commands

unlink-skills:
	@if [ -L $(SKILLS_DST) ]; then \
		rm $(SKILLS_DST); \
		echo "Removed symlink $(SKILLS_DST)"; \
	else \
		echo "$(SKILLS_DST) is not a symlink, leaving alone"; \
	fi

unlink-commands:
	@if [ -L $(COMMANDS_DST) ]; then \
		rm $(COMMANDS_DST); \
		echo "Removed symlink $(COMMANDS_DST)"; \
	else \
		echo "$(COMMANDS_DST) is not a symlink, leaving alone"; \
	fi

status:
	@for pair in "$(SKILLS_DST)" "$(COMMANDS_DST)"; do \
		if [ -L $$pair ]; then \
			echo "$$pair -> $$(readlink $$pair)"; \
		elif [ -e $$pair ]; then \
			echo "$$pair exists but is NOT a symlink"; \
		else \
			echo "$$pair does not exist"; \
		fi; \
	done
