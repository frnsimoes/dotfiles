PI_DIR := $(HOME)/.pi/agent

# Each entry is a config item symlinked from this repo into $(PI_DIR).
# Runtime/secret files (auth.json, npm/, sessions/, mcp-*cache*) are NOT tracked.
ITEMS := extensions settings.json mcp.json

.PHONY: install link unlink status

install: link

link:
	@mkdir -p $(PI_DIR)
	@for item in $(ITEMS); do \
		src=$(CURDIR)/$$item; dst=$(PI_DIR)/$$item; \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then \
			echo "ERROR: $$dst exists and is not a symlink. Move/remove it first."; \
			exit 1; \
		fi; \
		ln -sfn "$$src" "$$dst"; \
		echo "Linked $$dst -> $$src"; \
	done

unlink:
	@for item in $(ITEMS); do \
		dst=$(PI_DIR)/$$item; \
		if [ -L "$$dst" ]; then \
			rm "$$dst"; echo "Removed symlink $$dst"; \
		else \
			echo "$$dst is not a symlink, leaving alone"; \
		fi; \
	done

status:
	@for item in $(ITEMS); do \
		dst=$(PI_DIR)/$$item; \
		if [ -L "$$dst" ]; then \
			echo "$$dst -> $$(readlink $$dst)"; \
		elif [ -e "$$dst" ]; then \
			echo "$$dst exists but is NOT a symlink"; \
		else \
			echo "$$dst does not exist"; \
		fi; \
	done
