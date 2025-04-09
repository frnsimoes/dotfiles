# Monitor stuff
#
monitor-1920:
	xrandr --output DP-1 --mode 1920x1080 

xrand-monitor-2560:
	xrandr --output DP-1 --mode 2560x1440 --scale 0.5x0.5
#
xrand-monitor-max-3840:
	xrandr --output DP-1 --auto --scale 0.5x0.5 

laptop-display-off:
	xrandr --output eDP-1 --off

laptop-display-on:
	xrandr --output eDP-1 --auto

setup-external-monitor: monitor-1920  laptop-display-off

# Flatpak, if im using i3
flatpak:
	./bin/scripts/flatpak-open.sh # Audio sutff
audio-switcher:
	./bin/scripts/audioswitch.sh

spotify-toggle-audio:
	python ./bin/scripts/mute-spotify.py


# Personal stuff
include .env
export $(shell sed 's/=.*//' .env)

addr:
	echo $(ADDRESS) | xclip -selection clipboard

cpf:
	echo $(CPF) | xclip -selection clipboard

cel:
	echo $(CEL) | xclip -selection clipboard

start-meeting:
	pkill telegram & pkill thunderbird

end-work:
	pkill chrome || echo "chrome not running"
	pkill Discord || echo "Discord not running"
	
	sudo wg-quick down fernando_simoes
	
	ip link show | grep "fernando_simoes" || echo "Interface fernando_simoes is down"

building:
	cd /home/frns/documents/boring_stuff/building

people:
	cd /home/frns/documents/personal/people

joaquim:
	cd /home/frns/documents/personal/people


