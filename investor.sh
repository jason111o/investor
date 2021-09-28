#!/usr/bin/env bash

#### Vars
title="Pip's Investment Calculator"
text="Fill in the entries to calculate growth of wealth"

#### Confirming numerical input
num_check() {
  for (( i=0; i<${#1}; i++ )); do
    if [[ ${1:$i:1} != [0-9] ]]; then
      zenity --error --title "$title" --text "Only numerical data is allowed \"$1\""
      return 1
    else
      return 0
    fi
  done
}

#### Get basic investment data
get_investment_data() {
	investment_data=$(zenity --forms \
		--title "$title" \
		--text $text \
		--add-entry="Initial Amount" \
		--add-entry="10 Year Return Rate" \
		--add-entry="Years To Invest")
	if [[ $? != 0 ]]; then
		exit 99
	fi
	initial_investment=$(echo $investment_data | cut -d \| -f 1)
	ten_year_return=$(echo $investment_data | cut -d \| -f 2)
	years_to_invest=$(echo $investment_data | cut -d \| -f 3)
	num_check $initial_investment
	num_check $ten_year_return
	num_check $years_to_invest
	return $initial_investment $ten_year_return $years_to_invest
}

data=get_investment_data
echo "Returned from get_investent_data: data"

#### Will the additional investments be yearly or monthly
zenity --question --title "$title" --text "Will there be monthly investments?"
if [[ $? != 0 ]]; then
	exit 99
fi
if [[ $? == 0 ]]; then
	yearly_investment=$(zenity --forms \
		--title $title \
		--text $text \
		--add-entry="Amount")
	#*For testing*#
	echo Yearly has been chosen with the amount of: $yearly_investment
else
	monthly_investment=$(zenity --forms \
		--title $title \
		--text $text \
		--add-entry="Amount")
	#*For testing*#
	echo Monthly has been chosen with the amount of: $monthly_investment
fi
