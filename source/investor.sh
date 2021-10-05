#!/usr/bin/env bash
source ./functions.sh

#### Vars
title="Pip's Investment Calculator"
text="Fill in the entries to calculate growth of wealth"
version=1.0
case $1 in
  "-v")
  echo -e "\n$title\n$version\n"
  exit 0
  ;;
esac

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
initial_investment=$(echo $investment_data | cut -d \| -f 1)
ten_year_return=$(echo $investment_data | cut -d \| -f 2)
years_to_invest=$(echo $investment_data | cut -d \| -f 3)
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

#### Will the additional investments be montly, yearly, or not at all
zenity --question --title "$title" --text "Will there be monthly investments?"
if [[ $? == 0 ]]; then
	monthly_investment=$(zenity --forms \
      --title $title \
	  --text $text \
	  --add-entry="Amount")
    investing_monthly $initial_investment $ten_year_return $years_to_invest $monthly_investment
    exit 0
fi
zenity --question --title "$title" --text "Will there be yearly investments?"
if [[ $? == 0 ]]; then
  yearly_investment=$(zenity --forms \
    --title $title \
    --text $text \
    --add-entry="Amount")
    investing_yearly $initial_investment $ten_year_return $years_to_invest $yearly_investment
    exit 0
else
  ## If not monthly or yearly... run it :)
  investing_growth $initial_investment $ten_year_return $years_to_invest
  exit 0
fi

exit 0
