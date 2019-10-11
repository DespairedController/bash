#!/bin/bash
if [ $1 -gt $2 ]; then
  if [ $1 -gt $3 ]; then
    echo $1
  else 
    echo $3
  fi
 else
   if [ $3 -gt $2 ]; then
    echo $3
  else 
    echo $2
  fi
fi