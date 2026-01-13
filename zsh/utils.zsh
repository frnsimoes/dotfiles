alias curdate='date +%d-%m-%Y'

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


n() {
    local dir=~/me/notes/${1:-personal}
    local file
    file=$(find "$dir" -maxdepth 5 -name '*.md' 2>/dev/null \
        | fzf --height=40% --border)
    [ -n "$file" ] && vim "$file"
}

alias np='n personal'
alias nw='n work'

trouble() {
  case "$1" in
    cpu)
      echo "mpstat            - CPU per core"
      echo "pidstat 1         - CPU per process | %usr %sys | -p <pid>"
      echo "top -1            - separated cores"
      echo "vmstat 5 -w       - us (user s) sy (kernel s) id (idle)"
      ;;
    mem)
      echo "free -h           - overview"
      echo "vmstat 1          - swap in/out"
      echo "slabtop           - kernel memory"
      ;;
    io)
      echo "iostat -x 1       - disk details"
      echo "iotop             - I/O per process"
      ;;
    net)
      echo "ss -tlnp          - open ports"
      echo "nstat             - TCP counters"
      ;;
    *)
      echo "cpu | mem | io | net"
      ;;
  esac
}
