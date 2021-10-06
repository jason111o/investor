#!/usr/bin/env bash

#### Vars
title="Pip's Investment Calculator"
text="Fill in the entries to calculate growth of wealth"
version=1.1
case $1 in
  "-v")
  echo -e "\n$title\n$version\n"
  exit 0
  ;;
esac

################################################################################
###################################FUNCTIONS####################################
#### Confirming numerical values
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
###################################FUNCTIONS####################################
################################################################################

#### Set up zenity error for validating numerical values
warning="zenity --error --title $title"

#### Get basic investment data
investment_data=$(zenity --forms \
	--title "$title" \
	--text $text \
	--add-entry="Initial Investment" \
	--add-entry="10 Year Return %" \
	--add-entry="Years Planned To Invest")
if [[ $? != 0 ]]; then
	exit 99
fi

#### Seperate data values
initial_investment=$(echo $investment_data | cut -d \| -f 1)
ten_year_return=$(echo $investment_data | cut -d \| -f 2)
years_to_invest=$(echo $investment_data | cut -d \| -f 3)

#### Validate data values
num_check $initial_investment
if [[ $? != 0 ]]; then
  $warning --text "\"$initial_investment\" is not a numerical value"
  exit 0
fi
num_check $ten_year_return
if [[ $? != 0 ]]; then
  $warning --text "\"$ten_year_return\" is not a numerical value"
  exit 0
fi
num_check $years_to_invest
if [[ $? != 0 ]]; then
  $warning --text "\"$years_to_invest\" is not a numerical value"
  exit 0
fi

#### Monthly investments?
zenity --question --title "$title" --text "Will there be monthly investments?"
if [[ $? == 0 ]]; then
	monthly_investment=$(zenity --forms \
      --title $title \
	  --text $text \
	  --add-entry="Amount")
    investing_monthly $initial_investment $ten_year_return $years_to_invest $monthly_investment
    exit 0
fi

#### Yearly investments?
zenity --question --title "$title" --text "Will there be yearly investments?"
if [[ $? == 0 ]]; then
  yearly_investment=$(zenity --forms \
    --title $title \
    --text $text \
    --add-entry="Amount")
    investing_yearly $initial_investment $ten_year_return $years_to_invest $yearly_investment
    exit 0
else
  ## Computate growth if neither monthly or yearly were selected
  investing_growth $initial_investment $ten_year_return $years_to_invest
  exit 0
fi

exit 0
