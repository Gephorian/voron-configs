#!/usr/bin/env bash

if [ "$(readlink ~/printer.cfg)" != "$PWD/printer.cfg" ]; then
  echo -e "This will refresh this repository with the running copy because Klipper makes SCM difficult.\n\n"
  git status
  echo -e "\n\n"
  read -p "Continue? Ctrl+C to cancel."

  cp ~/printer.cfg .
  ./install.sh -d
  git add printer.cfg
  git commit && git push
else
  echo "Already in the desired state. Doing nothing."
fi
