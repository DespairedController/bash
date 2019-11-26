#!/bin/bash
#
#colors
red=$'\u001b[31m'
magenta=$'\u001b[35m'
yellow=$'\u001b[33m'
escape=$'\u001b[0m'

dir=$(cat .dir)
echo $dir
while true; do
  read -p "${yellow}file to read: ${escape}" file
  
  if [[ $file =~ ^/.* ]]; then
    file=${file:1:${#file}-1}
  fi
  path=$(realpath -q "${dir}/${file}")
  if [[ $path =~ ${dir}/* ]]; then
    if [[ -f $path ]]; then
      cat $path
    else
      echo "${red}ERROR:${escape} Not found"
    fi  
  elif [[ $path == "" ]]; then
    echo "${red}ERROR:${escape} Not found"
  else
    echo "${red}Ooops, seems like you want to cheat. Don't do that${escape}"
  fi
  sleep 1
done  
