alias curdate='date +%d-%m-%Y'

clean-docker() {
	echo 'Removing containers'
	for container in $(docker ps -a | awk '{print $1}'); do
	    docker rm $container;
	done

	echo 'Removing unused images'
	# Remove images
	for container in $(docker images -a | grep '<none>' | awk '{print $3}'); do
	    docker rmi $container;
	done
}


rb() {
    local highnote=4c-87-5d-81-ce-65

    echo "Turning off Bluetooth..."
    blueutil --power 0

    echo "Turning on Bluetooth..."
    blueutil --power 1

    echo "Connecting to device with MAC address $highnote..."
    blueutil --connect "$highnote"
}



gt() {
    selected_dir=$(find . -type d -not -path '*/.*' 2>/dev/null | fzf --height=40% --border --preview 'ls -la {}')
    if [ -n "$selected_dir" ]; then
        cd "$selected_dir"
        echo "Moved to: $selected_dir"
    else
        echo "No directory selected"
    fi
}
