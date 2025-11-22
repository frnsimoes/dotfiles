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

gt() {
    base_dir="${2:-.}"
    base_dir="$(realpath "$base_dir")"
    default_depth="${1:-50}"

    display_depth=3
    selected_dir=$(find "$base_dir" -maxdepth "$default_depth" -type d -not -path '*/.*' 2>/dev/null \
        | awk -v dd="$display_depth" -F/ '{n=NF<dd?1:NF-dd+1; out=$(n); for(i=n+1;i<=NF;i++) out=out"/"$(i); printf "%s\t%s\n", $0, out}' \
        | fzf --height=40% --border --preview 'ls -la {1}' --with-nth=2 \
        | cut -f1)

    if [ -n "$selected_dir" ]; then
        cd "$selected_dir"
    else
        echo "No directory selected"
    fi
}
