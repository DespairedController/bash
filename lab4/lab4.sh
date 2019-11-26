#!/bin/bash
#
#
red=$'\u001b[31m'
magenta=$'\u001b[35m'
yellow=$'\u001b[33m'
escape=$'\u001b[0m'

sendall() {
  cnt=0
  query=$1
  signal=$2
  for p in $(find /proc -maxdepth 2 -mindepth 2 -name cmdline); do
    if [[ -f $p ]]; then
      cmd=$(tr -d '\0' <"${p}")
      if [[ $cmd == *$query* ]]; then
        pid=$(echo $p | cut -d/ -f3)
        kill $2 $pid
        cnt=$((cnt + 1))
      fi
    fi
  done
  printf "%-80s\n" "${yellow}Search done. ${cnt} processes killed.${escape}"
}

list_processes() {
  for p in /proc/*; do
    pid=$(echo $p | cut -d/ -f3)
    if [[ "${pid}" =~ ^[0-9]+$ ]]; then
      cmd=$(tr -d '\0' <"${p}/cmdline")
      printf "%-8s  %.80s\n" "$pid" "$cmd"
    fi
  done
}

# takes two args: error name and comand usage
error() {
  printf "%-16s %-32s\n" "${red}ERROR:${escape}" "${1}"
  if [[ $# == 2 ]]; then
    printf "%-7s %-32s\n" " " "${magenta}Usage: ${2}${escape}"
  fi
}

show_info() {
  ppid=$(awk '/PPid/ {print $2; }' "/proc/${1}/status")
  cmd=$(tr -d '\0' <"/proc/${ppid}/cmdline")
  uid=$(awk '/Uid/ {print $2, $3, $4, $5; }' "/proc/${1}/status")
  cwd=$(readlink -e "/proc/${1}/cwd")
  mem=$(awk '{print $1; }' "/proc/${1}/statm")
  exe=$(readlink -f /proc/${1}/exe)

  printf "\n%-15s  %.80s\n" "${magenta}PPid:${escape}" "$ppid"
  printf "%-15s  %.80s\n" "${magenta}Pcmd:${escape}" "$cmd"
  printf "%-15s  %.80s\n" "${magenta}Uid:${escape}" "$uid"
  printf "%-15s  %.80s\n" "${magenta}Cwd:${escape}" "$cwd"
  printf "%-15s  %.80s\n" "${magenta}Mem:${escape}" "$mem"
  printf "%-15s  %.80s\n\n" "${magenta}Exe:${escape}" "$exe"
}

help() {
  printf "\n%-30s  %.80s\n" "${yellow}list${escape}" "list processes in two columns: <PID> <CMD>"
  printf "%-30s  %.80s\n" "${yellow}info <PID>${escape}" "show info about process"
  printf "%-30s  %.80s\n" "${yellow}find <QUERY>${escape}" "find all processes, cmd of which contains <QUERY>"
  printf "%-30s  %.80s\n" "${yellow}send <SIGNAL> <PID>${escape}" "send signal <SIGNAL> to process <PID>"
  printf "%-30s  %.80s\n" "${yellow}stream${escape}" "online log for process starting/finishing"
  printf "%-30s  %.80s\n\n" "${yellow}exit${escape}" "exit program"
}

find_all_by_query() {
  cnt=0
  query=$1
  for p in $( find /proc -maxdepth 2 -mindepth 2 -name cmdline); do
    if [[ -f $p ]]; then
      cmd=$(tr -d '\0' <"${p}")
      if [[ $cmd == *$query* ]]; then
        echo $p | cut -d/ -f3
        cnt=$((cnt + 1))
      fi
    fi
  done
  printf "%-80s\n" "${yellow}Search done. ${cnt} processes found.${escape}"
}

while true; do
  IFS=' ' read -p "${yellow}procm> ${escape}" -a args
  case "${args[0]}" in
    sendall)
      sendall ${args[2]} ${args[1]}
      ;;
    list)
      if [[ ${#args[@]} > 1 ]]; then
        error "Wrong number of arguments" "list"
      else 
        list_processes
      fi
      ;;
    info)
      if [[ ${#args[@]} != 2 ]]; then
        error "Wrong number of arguments" "info <PID>"
      elif [[ ! "${args[1]}" =~ ^[0-9]+$ ]]; then
        error "Argument must be a positive integer" "info <PID>"
      else 
        show_info "${args[1]}"
      fi
      ;; 
    send)
      if [[ ${#args[@]} != 3 ]]; then
        error "Wrong number of arguments" "send <SIGNAL> <PID>"
      elif [[ ! "${args[2]}" =~ ^[0-9]+$ ]]; then
        error "<PID> must be a positive integer" "send <SIGNAL> <PID>"
      else 
        kill ${args[1]} ${args[2]}
      fi
      ;;
    find)
      if [[ ${#args[@]} != 2 ]]; then
        error "Wrong number of arguments" "find <QUERY>"
      else 
        find_all_by_query "${args[1]}"
      fi
      ;;
    stream)
      ./stream.sh
      ;;  
    help)
      help
      ;;  
    exit)
      exit 0
      ;;
    "")
      ;;
    *)
      error "Unknown command: ${args[0]}"
  esac
done
