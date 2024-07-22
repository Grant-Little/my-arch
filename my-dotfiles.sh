#!/usr/bin/bash
set -euo pipefail
# wip

if [[ $EUID -eq 0 ]]; then
  echo "do not run as root"
  exit 1
fi

DOTFILES_GIT="https://github.com/Grant-Little/dotfiles.git"
git clone $DOTFILES_GIT
if [ -d ~/.config/ ]; then
  echo ".config directory exists"
else
  echo "making .condig directory"
  mkdir ~/.config
fi

mv dotfiles/.config/* $HOME/.config/

exit 0
