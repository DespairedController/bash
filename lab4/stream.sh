#!/bin/bash
red=$'\u001b[31m'
magenta=$'\u001b[35m'
yellow=$'\u001b[33m'
escape=$'\u001b[0m'

trap ctrl_c SIGINT
trap ctrl_c SIGTERM

ctrl_c() {
  echo -e "\n${yellow}stream finished${escape}"
  exit 0
}

last_started=-1
declare -A processes
for p in /proc/*; do
      pid=$(echo $p | cut -d/ -f3)
      if [[ "${pid}" =~ ^[0-9]+$ ]]; then
        if [[ ! -v processes[$pid] ]]; then
          cmd=$(tr -d '\0' <"${p}/cmdline")
          processes+=([$pid]=$cmd)
        fi
      fi
    done

while true; do
  cur_started=$(cat /proc/loadavg | cut -d" " -f5)
  if [[ $cur_started != $last_started ]]; then
    for p in /proc/*; do
      pid=$(echo $p | cut -d/ -f3)
      if [[ "${pid}" =~ ^[0-9]+$ ]]; then
        if [[ ! -v processes[$pid] ]]; then
          cmd=$(tr -d '\0' <"${p}/cmdline")
          processes+=([$pid]=$cmd)
        printf "Process %s (%s) started\n" "${pid}" "${cmd}"
        fi
      fi
    done
    for pid in ${!processes[@]}; do
      if [[ ! -d "/proc/${pid}" ]]; then
        cmd=$(echo ${processes["${pid}"]} | cut -c 1-80)
        printf "Process %s (%s) finished\n" "${pid}" "${cmd}"
        unset processes["${pid}"]
      fi
    done
  fi
  sleep 2
done