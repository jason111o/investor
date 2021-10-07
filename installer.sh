#!/usr/bin/env bash

if [[ $EUID != 0 ]]; then
	printf "\nInstaller must be run as root\n\n"
	exit 1
fi

printf "\nInstalling investor"
for (( x=0; x<3; x++ )); do
	sleep 1
	printf ". "
done

if [[ -e source/investor.sh ]]; then
	cp source/investor.sh /usr/local/bin/investor
	if [[ $? != 0 ]]; then
		exit 1
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
Icon=/usr/share/icons/gnome/48x48/apps/accessories-calculator.png' \
		> /usr/share/applications/investor.desktop
	chown root:root /usr/share/applications/investor.desktop
	chmod 0644 /usr/share/applications/investor.desktop
else
	printf "\n\ninvestor Installer must be run from within the investor directory\n\n"
	exit 1
fi

printf "\n\nInstallation finished!\n\n"

exit 0
