#!/usr/bin/env sh

set -ue

OS="$(uname -s)"
mod_folder="portraitcolors"
outfile="$mod_folder/tmp"

if [ "$OS" = "Darwin" ]; then
  OS="macos"

  for file in *.app/Contents/MacOS/*-macOS
  do
    if [ -f "$file" ]; then
      exe="$file"
      md5=$(md5 -q "$exe")
      break
    fi
  done

elif [ "$OS" = "Linux" ]; then
  OS="linux"
  arch=''

  if [ "$(uname -m)" = "x86_64" ]; then
    arch='64'
  fi

  for suffix in $arch ''; do
    for file in \
      BaldursGate \
      BaldursGateII \
      IcewindDale \
      Torment
    do
      if [ -f "$file$suffix" ]; then
        exe="$file$suffix"
        md5=$(md5sum "$exe" | cut -f 1 -d ' ')
        break 2 # break outer loop
      fi
    done
  done
else
  exit 1
fi

if [ ! -f "$exe" ]; then
  exit 2
fi

echo "OUTER_SPRINT game_exe ~$exe~" > "$outfile"

include="$mod_folder/data/$OS/$md5.tph"
if [ -f "$include" ]; then
  cat "$include" >> "$outfile"
fi
