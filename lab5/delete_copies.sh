#!/bin/bash

red=$'\u001b[31m'
magenta=$'\u001b[35m'
yellow=$'\u001b[33m'
escape=$'\u001b[0m'

# takes two args: error name and comand usage
error() {
  printf "%-16s %-32s\n" "${red}ERROR:${escape}" "${1}"
  if [[ $# == 2 ]]; then
    printf "%-7s %-32s\n" " " "${magenta}Usage: ${2}${escape}"
  fi
}

directory="${PWD}/**"
if [[ $# > 1 ]]; then
  error "Wrong number of arguments" "./fst.sh <OPTIONAL DIRECTORY>"
  exit 1
elif [[ $# == 1 ]]; then
  if [[ -d $1 ]]; then
    directory="$1/**"
  else  
    error "No such directory: ${1}"
    exit 1
  fi
fi

declare -A files
shopt -s globstar
for file in $directory; do
  [[ -f $file ]] || continue
  checksum=$(md5sum $file | awk '{ print $1 }')
  if [[ ! -v files[$checksum] ]]; then
    files+=([$checksum]=$file)
  else
    original=${files[$checksum]}
    echo "replacing ${file} on hardlink to ${original}"
    rm $file
    ln $original $file
  fi    
done