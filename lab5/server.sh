#!/bin/bash

dir="/tmp/files"
if [[ $# == 1 ]]; then
  dir=$1
fi 
echo $dir > .dir
nc -l -p 24344 -e handler.sh
