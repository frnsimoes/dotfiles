alias curdate='date +%d-%m-%Y'

gt() {
    local base_dir="${1:-.}"
    base_dir="$(realpath "$base_dir")"

    local selected_dir
    selected_dir=$(
        find "$base_dir" \
            \( -name '.*' -o -name 'node_modules' -o -name '__pycache__' \
               -o -name 'dist' -o -name '.tox' \) -prune \
            -o -type d -print 2>/dev/null |
        awk -F/ '{
            n = NF < 4 ? 1 : NF - 3
            out = $(n)
            for (i = n+1; i <= NF; i++) out = out "/" $(i)
            printf "%s\t%s\n", $0, out
        }' |
        fzf --height=40% --border --scheme=path \
            --preview 'ls -la {1}' \
            --with-nth=2 |
        cut -f1
    )

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
    [ -n "$file" ] && nvim "$file"
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

# Go to definition - Terraform
tfd() {
  rg -n "^(resource|module|data|variable|output|locals)\s+.*\b$1\b"
}

# Go to definition - Python
pyd() {
  rg -n "^(def|class)\s+$1\b"
}

# Find referente
ref() {
  rg -n "\b$1\b"
}

# Find where variable/resource is used - Terraform specific
tfref() {
  rg -n "(var\.$1|module\.$1|data\.$1|local\.$1)"
}

podscount() {
    kubectl get pods -n whatsapp -o wide --no-headers | awk '{print $7}' | sort | uniq -c | sort -rn
}


wk() {
    NOTES_DIR="$HOME/me/notes"

    declare -A FILE_MAP=(
        [til]="til.md"
        [work]="work-log.md"
    )

    case "$1" in
        til|work) files=("$NOTES_DIR/${FILE_MAP[$1]}") ;;
        "")       files=("$NOTES_DIR/til.md" "$NOTES_DIR/work-log.md") ;;
        *)        echo "Usage: $(basename "$0") [til|work]" >&2; exit 1 ;;
    esac

    today=$(date +%s)
    week_ago=$(date -v-7d +%s)

    for file in "${files[@]}"; do
        [[ -f "$file" ]] || { echo "File not found: $file" >&2; continue; }
        [[ ${#files[@]} -gt 1 ]] && echo "=== $(basename "$file") ==="
            awk -v today="$today" -v week_ago="$week_ago" '
            function to_epoch(d,    cmd, ep, day, mon, yr) {
                day = substr(d,1,2); mon = substr(d,4,2); yr = substr(d,7,4)
                cmd = "date -j -f \"%Y-%m-%d\" \"" yr "-" mon "-" day "\" +%s 2>/dev/null"
                cmd | getline ep
                close(cmd)
                return ep + 0
            }
        /^[0-9][0-9]-[0-9][0-9]-[0-9]{4}/ {
            in_range = (to_epoch(substr($0,1,10)) >= week_ago)
        }
    in_range { print }
    ' "$file"
    echo
done
}

