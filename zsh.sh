#!/bin/sh
desired="/usr/local/bin/zsh"
if [ $desired != $(echo $SHELL) ]; then
  judge=true
  for shell in $(cat /etc/shells)
  do
    if [ $desired = $shell ]; then
      judge=false
    fi
  done
  if $judge; then
    sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
  else
    echo "already included in etc/shells"
  fi
  chsh -s /usr/local/bin/zsh
  exec $SHELL -l
else 
  echo "already desired SHELL"
fi
