# Initial tasks to run on window boot up.

init() {
  enable_bash_rematch
  setopt BASH_REMATCH
  curwin
}

# Info about current terminal window and other things.
curwin() {
  hline=""
  for i in {0..55}; do
    hline+="\u2500"
  done

  [[ $SHELL == "/bin/zsh" ]] && setopt local_options BASH_REMATCH

  num_cores=$(system_profiler SPHardwareDataType | grep Cores)
  num_cores=$([[ $num_cores =~ ([[:digit:]]+) ]] && echo ${BASH_REMATCH[1]})

  echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mUser\x1B[0m:        \x1B[38;2;255;213;135m$(whoami)\x1B[0m"
  echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mOS Type\x1B[0m:     \x1B[38;2;255;213;135m$OSTYPE\x1B[0m"
  echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mTerminal\x1B[0m:    \x1B[38;2;255;213;135m$(tty)\x1B[0m"
  echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mShell\x1B[0m:       \x1B[38;2;255;213;135m$SHELL\x1B[0m"
  echo 
}

print_todos() {
  [[ -f $TODOS ]] && cat $TODOS
}

enable_bash_rematch() {
  setopt BASH_REMATCH
}
