#!/bin/bash
while true
do
  echo "Press 1 for nano, 2 for vi, 3 for links or 4 for exit"
  read Number
  case $Number in
    1)
      nano
      exit 0
      ;;
    2)
      vi
      exit 0
      ;;
    3)
      links
      exit 0
      ;;
    4)
      exit 0
      ;;  
    esac
done