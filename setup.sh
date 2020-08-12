#!/bin/bash

sudo_echo_link () {
  echo "linking '$1' → '$2'"
  sudo ln -sf "$1" "$2"
}

TD=/usr/bin
sudo_echo_link $(readlink -f compile.sh) "$TD/cm-viewlang"
