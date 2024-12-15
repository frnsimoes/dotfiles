clean-torrent:
	rm -rf torrent/*

clean-docker:
	./.dotfiles/scripts/clean-docker

set-dns:
	@echo "Choices are [cloudflare, google]"
	@read name; \
	if [ "$$name" = "cloudflare" ]; then \
		sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1 1.0.0.1; \
	elif [ "$$name" = "google" ]; then \
		sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 8.8.4.4; \
	else \
		echo "Invalid choice. Please choose either [cloudflare] or [google]."; \
		exit 1; \
	fi; 
	@networksetup -getdnsservers "Wi-Fi"
	@sudo cat /etc/resolv.conf | grep -i "name*"

highnote = 4c-87-5d-81-ce-65
refresh-bluetooth:
	# requires blueutil: brew install blueutil
	blueutil --power 0
	blueutil --power 1

	blueutil --connect $(highnote)
