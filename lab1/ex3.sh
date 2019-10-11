#!/bin/bash
Answer=""
while [[ "$CurrentLine" != "q" ]]
  do
    Answer=$Answer$CurrentLine
    read CurrentLine
  done
echo $Answer