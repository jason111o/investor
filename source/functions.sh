#!/usr/bin/env bash

#### This is a companion script to investor.sh
#### It must be in the same directory as the forementioned

#### Confirming numerical input
num_check() {
  for (( i=0; i<${#1}; i++ )); do
    if [[ ${1:$i:1} != [0-9] ]]; then
      return 1
    else
      return 0
    fi
  done
}

#### e.g. investing_growth $1(initial_investment) $2(ten_year_return) $3(years_to_invest)
investing_growth() {
  tyr=$(echo "$2 / 100" | bc -l) ## convert percentage to decimal
  ii=$1
  for (( i=1; i<=$3; i++ )); do
    growth=$(echo "$ii * $tyr" | bc -l)
    ii=$(echo "$ii + $growth" | bc -l)
  done
  result=$(printf "%'.2f" $ii) # Add commas to big numbers
  zenity --info --title "Pip's Investment Calculator" --text "\$$result"
}

#### e.g. investing_monthly $initial_investment $ten_year_return $years_to_invest $monthly_investment
investing_monthly() {
  tyr=$(echo "$2 / 100" | bc -l) ## convert percentage to decimal
  mr=$(echo "$tyr / 12" | bc -l) ## Monthly percentage
  months=$(echo "$3 * 12" | bc -l)
  ii=$1
  for (( i=1; i<=$months; i++ )); do
    growth=$(echo "$ii * $mr" | bc -l)
    ii=$(echo "$ii + $growth + $4" | bc -l)
  done
  result=$(printf "%'.2f" $ii) # Add commas to big numbers
  zenity --info --title "Pip's Investment Calculator" --text "\$$result"
}

#### e.g. investing_yearly $initial_investment $ten_year_return $years_to_invest $yearly_investment
investing_yearly() {
  tyr=$(echo "$2 / 100" | bc -l) ## convert percentage to decimal
  ii=$1
  for (( i=1; i<=$3; i++ )); do
    growth=$(echo "$ii * $tyr" | bc -l)
    ii=$(echo "$ii + $growth + $4" | bc -l)
  done
  result=$(printf "%'.2f" $ii) # Add commas to big numbers
  zenity --info --title "Pip's Investment Calculator" --text "\$$result"
}
