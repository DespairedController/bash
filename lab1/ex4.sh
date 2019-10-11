#!/bin/bash
Answer=0
while :
  do
    read CurrentLine
    if [ $((CurrentLine % 2)) == 1 ]; then
      ((Answer++))
    else
      break
    fi
  done
echo $Answer

