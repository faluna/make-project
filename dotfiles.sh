#!/bin/sh
if [ ! -d ~/dotfiles ];then
  git clone --depth 1 https://github.com/faluna/dotfiles.git ~/dotfiles
  bash ~/dotfiles/symlink.sh
else
  echo 'dotfiles has already existed'
fi
