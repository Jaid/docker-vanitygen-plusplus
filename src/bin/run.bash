#!/usr/bin/env bash
set -o errexit

if [[ -z $currency ]]; then
  printf >&2 'Variable $currency not existing\n'
  exit 1
fi

if [[ -z $prefix ]]; then
  printf >&2 'Variable $prefix not existing\n'
  exit 1
fi

inputFile=/results/input.lines
outputFolder=/results/$currency
outputFile=$outputFolder/catches.txt
logFile=$outputFolder/vanitygen.log

if [[ -f $outputFile ]]; then
  printf '\n╞═════════════════════════════════════════════════════════════════════════════╡\n' >>"$outputFile"
else
  mkdir --parents "$outputFolder"
fi
if [[ -f $logFile ]]; then
  printf '\n╞═════════════════════════════════════════════════════════════════════════════╡\n' >>"$logFile"
fi

if [[ -f $inputFile ]]; then
  truncate --size 0 $inputFile
fi
IFS=' ' read -r -a entries <<<"$prefix"
for entry in "${entries[@]}"; do
  printf '%s\n' "$entry" >>$inputFile
done

function main() {
  declare -a arguments=()
  arguments+=(-v) # verbose
  arguments+=(-f) # pattern file
  arguments+=("$inputFile")
  arguments+=(-C) # currency
  arguments+=("$currency")
  arguments+=(-o) # output file
  arguments+=("$outputFile")

  if [[ -z $amount ]]; then
    arguments+=(-a)
    arguments+=("$amount")
  else
    arguments+=(-k)
  fi
  ./vanitygen++ "${arguments[@]}"
}

main |& tee --append "$logFile"
