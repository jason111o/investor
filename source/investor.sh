#!/usr/bin/env bash

#### Vars
title="Pip's Investment Calculator"
text="Fill in the entries to calculate growth of wealth"
version=2.0
warning="zenity --error --title $title"
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
			$warning --text "Enter whole numbers only"
			exit 1
    fi
  done
}
#### Aquire investment strategy from user
#### e.g. investing_growth [initial_investment|rate_of_return|years_to_invest|monthly_contribution|yearly_contribution]
investing_growth() {
	# $1
	if [[ $1 == "" ]]; then
		initial_investment=0
	else
		initial_investment=$1
	fi
	# $2
	if [[ $2 == "" ]]; then
		yearly_rate=0
	else
		yearly_rate=$(echo "$2 / 100" | bc -l) ## convert percentage to decimal
	fi
	# $3
	if [[ $3 == "" ]]; then
		years_to_invest=0
		monthly_rate=0
	elif [[ $3 > 0 ]]; then
		years_to_invest=$(echo $3)
		monthly_rate=$(echo "$yearly_rate / 12" | bc -l)
	fi
	# $4
	if [[ $4 == "" ]]; then
		monthly_contribution=0
	else
		monthly_contribution=$(echo $4)
	fi
	# $5
	if [[ $5 == "" ]]; then
		yearly_contribution=0
	else
		yearly_contribution=$(echo $5)
	fi
	echo "****TESTING****
	initial_investment = \"$initial_investment\"
	yearly_rate = \"$yearly_rate\"
	years_to_invest = \"$years_to_invest\"
	monthly_contribution = \"$monthly_contribution\"
	yearly_contribution = \"$yearly_contribution\""
	if [[ $monthly_contribution > 0 ]]; then
		total_months=$(echo "$years_to_invest * 12" | bc -l)
		montly_rate=$(echo "$yearly_rate / 12" | bc -l)
		for (( i=0; i<$total_months; i++ )); do
			growth=$(echo "$initial_investment * $monthly_rate" | bc -l)
			initial_investment=$(echo "$initial_investment + $growth + $monthly_contribution" | bc -l)
			is_year=$(echo "$i % 12" | bc -l)
			if [[ $is_year == 0 ]] && [[ $yearly_contribution > 0 ]]; then
				initial_investment=$(echo "$initial_investment + $yearly_contribution" | bc -l)
			fi
			result=$(printf "%'.2f" $initial_investment) # Add commas to big numbers
		done
	fi
	if [[ $years_to_invest > 0 ]]; then
		for (( i=0; i<$years_to_invest; i++ )); do
			echo "i = $i" #*testing*#
			growth=$(echo "$initial_investment * $yearly_rate + $yearly_contribution" | bc -l)
			initial_investment=$(echo "$initial_investment + $growth" | bc -l)
		done
		result=$(printf "%'.2f" $initial_investment) # Add commas to big numbers
	else
		result=$(printf "%'.2f" $initial_investment) # Add commas to big numbers
	fi
  zenity --info --title "Pip's Investment Calculator" --text "Total Investment Growth \$$result"
}
###################################FUNCTIONS####################################
################################################################################

#### Get basic investment data
investment_data=$(zenity --forms \
	--title "$title" \
	--text $text \
	--add-entry="Initial Investment $" \
	--add-entry="Rate of Return %" \
	--add-entry="Years Planned To Invest" \
	--add-entry="Monthly Contribution $" \
	--add-entry="Yearly Contribution $")
if [[ $? != 0 ]]; then
	exit 99
fi

#### Seperate data values
initial_investment=$(echo $investment_data | cut -d \| -f 1)
rate_of_return=$(echo $investment_data | cut -d \| -f 2)
years_to_invest=$(echo $investment_data | cut -d \| -f 3)
monthly_contribution=$(echo $investment_data | cut -d \| -f 4)
yearly_contribution=$(echo $investment_data | cut -d \| -f 5)

#### Validate data values
num_check $initial_investment
num_check $rate_of_return
num_check $years_to_invest
num_check $monthly_investment
num_check $yearly_investment

investing_growth $initial_investment $rate_of_return $years_to_invest $monthly_contribution $yearly_contribution

exit 0
