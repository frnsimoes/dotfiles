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

alias curdate='date +%d-%m-%Y'

