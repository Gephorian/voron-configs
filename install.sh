#!/bin/bash

INSTALLDIR=~/printer_data/config

while getopts ":d" opt; do
  case "$opt" in
    d) DEBUG=true;;
    *) echo "Unknown option: $opt" >&2;;
  esac
done

info(){
  [ "$DEBUG" == 'true' ] || return 0
  echo "INFO: $1"
}

warn(){
  echo "WARNING: $1" >&2

}

error(){
  echo "ERROR: $1" >&2
  return 1
}

die(){
  echo "CRITICAL: $1" >&2
  exit 1
}

install(){
  FILE=${1-null}
  READLINK=readlink
  if [ -f ${FILE} ]; then
    info "Installing $FILE"
    ln -sf $($READLINK -f $FILE) ${INSTALLDIR}/$2 || error "Couldn't copy the file: $FILE!"
  elif [ -d ${FILE} ]; then
    info "Removing original and installing $FILE"
    [ -d ${INSTALLDIR}/$FILE ] && rm -rf ${INSTALLDIR}/$FILE
    ln -sf $($READLINK -f $FILE) ${INSTALLDIR}/$2 || error "Couldn't copy the directory: $FILE!"
  else
    error "File ${FILE} doesn't exist!"
  fi
}

# Create ~/bin if it doesn't exist
if [ ! -d ~/bin ]; then
  mkdir ~/bin
fi

for i in *.cfg; do
  install $i
done

for i in klicky; do
  install $i
done
