cursor_vis() {
  echo "\x1b[?25h"
}

s() {
  if [[ "$SHELL" =~ "zsh" ]]; then
    source $HOME/.zshrc
  elif [[ "$SHELL" =~ "bash" ]]; then
    source $HOME/.bash_profile
  fi
}

j() {
  local bookmarks="$HOME/.bookmarks"

  if [[ ! -f "$bookmarks" ]]; then
    touch "$bookmarks"
  fi

  if [[ "$*" =~ "(-h|--help)" ]]; then
    read -r -d "" usage << EOT
USAGE:
  j [ARGUMENT] [OPTIONS]

ARGUMENT:
  Name of book mark to cd into.

OPTIONS:
  -h, --help          Display usage text.
  -l                  Display all bookmarks.
  -d <bookmark>       Bookmark to delete.
  -c <bookmark>       Bookmark to create.
EOT

    echo "$usage"
    return
  fi

  case $1 in
    "-l")
      cat "$bookmarks"
      ;;

    "-c")
      if [[ -z "$2" ]]; then
        echo "Missing argument for -c" 
        return
      fi
      
      local bookmark="${2}=$(pwd)"
      if [[ -z $(grep "$bookmark" "$bookmarks") ]]; then
        echo $bookmark >> $bookmarks
        echo $bookmark
      else
        echo "Bookmark '$bookmark' already exists."
      fi
      ;;

    "-d")
      local pat="/^$2=.*/d"
      sed -i "" "$pat" "$bookmarks"
      cat "$bookmarks"
      ;;

    *)
      local target=$(grep "$1=" "$HOME/.bookmarks")
      local result=${target/$1=/}
      cd "$result"
      ;;
  esac
}


gitinfo() {
  # Will not work unless setopt BASH_REMATCH.

  local project_root=$(git rev-parse --show-toplevel 2> /dev/null)
  
  if [[ -z $project_root ]]; then
    return
  fi

  local current_branch=$(git branch --show-current) 

  git diff-index --quiet HEAD -- 2> /dev/null || uncommitted_changes=true

  local styled_branch_name="::\e[1;38;5;220m$current_branch\e[0m"

  if [[ ! $uncommitted_changes ]]; then 
    printf $styled_branch_name 
    return
  fi

  local stats=$(git diff --stat)

  if [[ -z $stats ]]; then
    printf $styled_branch_name
    return
  fi

  [[ $stats =~ "[[:digit:]]+ insertion" ]] && insertions=${BASH_REMATCH[1]/ insertion/""}
  [[ $stats =~ "[[:digit:]]+ deletion" ]] && deletions=${BASH_REMATCH[1]/ deletion/""}

  if [[ ! -z $insertions && ! -z $deletions ]]; then
    printf "$styled_branch_name::<\e[1;38;2;149;199;111m+\e[0m$insertions\e[36m|\e[0m\e[1;31m-\e[0m$deletions>"
  elif [[ ! -z $insertions && -z $deletions ]]; then
    printf "$styled_branch_name::<\e[1;38;2;149;199;111m+\e[0m$insertions>"
  elif [[ -z $insertions && ! -z $deletions ]]; then
    printf "$styled_branch_name::<\e[1;31m-\e[0m$deletions>"
  else
    printf "$styled_branch_name::<\e[1;38;2;149;199;111m\e[0m$insertions\e[36m|\e[0m\e[1;31m-\e[0m$deletions>"
  fi
}

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
