#!/usr/bin/env bash

if [[ $EUID != 0 ]]; then
	printf "\nInstaller must be run as root\n\n"
	exit 1
fi

printf "\nInstalling investor"
for (( x=0; x<3; x++ )); do
	sleep 0.5
	printf ". "
done

if [[ -e ./source/investor.sh ]] && [[ ./source/calculator.png ]]; then
	cp source/investor.sh /usr/local/bin/investor
	if [[ $? != 0 ]]; then
		exit 1
	fi
	if [[ ! -d /usr/local/share/investor ]]; then
		mkdir -p /usr/local/share/investor/icons
		cp ./source/calculator.png /usr/local/share/investor/icons
		if [[ $? != 0 ]]; then
			exit 1
		fi
	fi
	chmod 0755 /usr/local/bin/investor
	echo '[Desktop Entry]
Name=Investor
GenericName=Investment Calculator
Comment=A very simple calculator for your investments
Exec=investor
Terminal=false
Type=Application
Categories=Office
Keywords=investor;math;utility;office
Icon=/usr/local/share/investor/icons/calculator.png' > /usr/share/applications/investor.desktop
	chown root:root /usr/share/applications/investor.desktop
	chmod 0644 /usr/share/applications/investor.desktop
else
	printf "\n\n\"./source\" directory not found!\n\n"
	exit 1
fi

printf "\n\nInstallation complete!\nRun it from the cli or find it in the Office category\n\n"

exit 0
