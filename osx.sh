#!/bin/sh

# ===========================
# Setup MacOS defaults
# ===========================

if [ "$(uname)" != "Darwin" ]; then
  echo 'Not macOS!'
else
  echo 'Setup MacOS'

  chflags nohidden ~/Library  # ~/Library directory  可視化
  sudo chflags nohidden /Volumes  # /Volumes  可視化
  sudo nvram SystemAudioVolume=" "

  csvfile=defaults-list.csv
  for line in `cat ${csvfile} | grep -v ^#`
  do
    first=`echo ${line} | cut -d ',' -f 1`
    second=`echo ${line} | cut -d ',' -f 2`
    third=`echo ${line} | cut -d ',' -f 3`

    defaults write ${first} ${second} ${third}
  done

  defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Clock.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu"

  echo 'Finished'
fi

# -----------------------------
