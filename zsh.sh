#!/bin/sh
desired="/usr/local/bin/zsh"
if [ $desired != $(echo $SHELL) ]; then
  judge=false
  for shell in $(cat /etc/shells)
  do
    if [ $desired = $shell ]; then
      judge=true
    fi
  done
  if ! "${judge}"; then
    echo /usr/local/bin/zsh >> /etc/shells
  else
    echo "already included in etc/shells"
  fi
  chsh -s /usr/local/bin/zsh
else 
  echo "already desired SHELL"
fi
