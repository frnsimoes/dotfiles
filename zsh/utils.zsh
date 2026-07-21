alias curdate='date +%d-%m-%Y'

gt() {
    // requires fd (brew install fd)
    local base_dir="${1:-.}"
    base_dir="$(realpath "$base_dir")"

    local selected_dir
    if command -v fd >/dev/null 2>&1; then
        selected_dir=$(
            fd --type d --hidden --follow \
               --exclude .git --exclude node_modules --exclude __pycache__ \
               --exclude dist --exclude .tox --exclude .venv --exclude venv \
               --exclude target --exclude build --exclude .terraform \
               . "$base_dir" |
            fzf --height=40% --border --scheme=path --tiebreak=end \
                --preview 'ls -la {}' \
                --delimiter=/ --with-nth=-4..
        )
    else
        selected_dir=$(
            find "$base_dir" \
                \( -name '.*' -o -name 'node_modules' -o -name '__pycache__' \
                   -o -name 'dist' -o -name '.tox' -o -name '.venv' \
                   -o -name 'venv' -o -name 'target' -o -name 'build' \
                   -o -name '.terraform' \) -prune \
                -o -type d -print 2>/dev/null |
            fzf --height=40% --border --scheme=path --tiebreak=end \
                --preview 'ls -la {}' \
                --delimiter=/ --with-nth=-4..
        )
    fi

    if [ -n "$selected_dir" ]; then
        cd "$selected_dir"
    else
        echo "No directory selected"
    fi
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

