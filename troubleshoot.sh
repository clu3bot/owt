#!/bin/bash/
#owt trouble shoot
#created by clu3bot (Brennan Mccown)

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
#echowrap
e() {
echo -e "$@"
}
#output
output() {
e "${LBLUE}Output${NONE}    ${GREEN}GREEN${NONE} is good   ${LRED}RED${NONE} is bad"
e "${LBLUE}------------------------------------${NONE}"
}

#check if a wireless interface exists
check_interface() {
iface=$(airmon-ng | awk 'NR==4' | awk '{print $2}')
if [[ -z "${iface// }" ]]; then
iface="null"
fi
}
ifacestatus() {
if [ "${iface}" == "null" ]; then
e "${LRED}No wireless interface found${NONE}"
else
e "${GREEN}Wireless interface found${NONE}"
fi
}
#display for check if a wireless interface exists
display_check_interface() {
clear
output
check_interface 
e "${LRED}Checking for wireless interface..${NONE}"
sleep 2
if [[ "${iface}" == "null" ]]; then
e "${LRED}No wireless interface found${NONE}"
else
e "${GREEN}Wireless interface found${NONE}"
fi
sleep 1
clear
if [[ "${iface}" == "null" ]]; then
output
e "${LRED}No wireless interface found${NONE}"
e "${LBLUE}------------------------------------${NONE}"
else
output
e "${GREEN}Wireless interface found${NONE}"
e "${LBLUE}------------------------------------${NONE}"
fi
}
#check if device can be put in monitor mode
check_monitor() {
if [ "${iface}" == "null" ]; then
mode="null"
fi
}

monitorstatus() {
if [ "${mode}" == "null" ]; then
e "${LRED}Interface is not suitable for Monitor Mode${NONE}"
else
e "${GREEN}Interface is suitable for Monitor Mode${NONE}"
fi
}

#display for check if device can be put in monitor mode
display_check_monitor() {
check_monitor 
e "${LRED}Checking for interface..${NONE}"
sleep 1
e "${LRED}Checking if interface is suitable for Monitor Mode${NONE}"
sleep 1
if [ "${mode}" == "null" ]; then
e "${LRED}Interface is not suitable for Monitor Mode${NONE}"
else
e "${GREEN}Interface is suitable for Monitor Mode${NONE}"
fi
clear
if [ "${mode}" == "null" ]; then
output
ifacestatus
e "${LRED}Interface is not suitable for Monitor Mode${NONE}"
e "${LBLUE}------------------------------------${NONE}"
else
output
ifacestatus
e "${GREEN}Interface is suitable for Monitor Mode${NONE}"
e "${LBLUE}------------------------------------${NONE}"
fi
}

#check if all dependencies are installed
check_dependencies() {
dependencies=(aircrack-ng mdk3 xterm macchanger)
for d in "${dependencies[*]}"; do
if [ "$(dpkg-query -W -f='${Status}' $d 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
dependencies="null"
fi
done
}
dependenciesstatus() {
if [[ "${dependencies}" == "null" ]]; then
e "${LRED}Missing Required Dependencies${NONE}"
else
e "${GREEN}All Dependencies Installed${NONE}"
fi
}
#display for check if all dependencies are installed
display_check_dependencies() {
check_dependencies &
e "${LRED}Scanning Directories..${NONE}"
sleep 1.25
e "${LRED}Checking for Dependencies..${NONE}"
sleep 1.25
if [[ "${dependencies}" == "null" ]]; then
e "${LRED}Missing Required Dependencies${NONE}"
else
e "${GREEN}All Dependencies installed${NONE}"
fi
clear
if [ "${dependencies}" == "null" ]; then
output
ifacestatus
monitorstatus
e "${LRED}Missing required Dependencies${NONE}"
e "${LBLUE}------------------------------------${NONE}"
else
output
ifacestatus
monitorstatus
e "${GREEN}All Dependencies installed${NONE}"
e "${LBLUE}------------------------------------${NONE}"
fi
}
#check if user is on a distro of linux that is supported
check_distro() {
di=$(lsb_release -is)
if [[ -z "${di// }" ]]; then
distro="null"
fi
}
distrostatus() {
if [ "${distro}" == "null" ]; then
e "${LRED}The distrobution of linux you are using is not supported${NONE}"
else
e "${GREEN}Compatible Linux Distrobution${NONE}"
fi
}

#display for check if user is on a distro of linux that is supported
display_check_distro() {
check_distro 
e "${LRED}Checking linux Distrobution..${NONE}"
sleep 1.25
e "${LRED}Checking compatibility..${NONE}"
sleep 1.25
if [ "${distro}" == "null" ]; then
e "${LRED}The distrobution of linux you are using is not supported${NONE}"
else
e "${GREEN}Compatible Linux Distrobution${NONE}"
fi
clear
if [ "${distro}" == "null" ]; then
output
ifacestatus
monitorstatus
dependenciesstatus
e "${LRED}The distrobution of linux you are using is not supported${NONE}"
e "${LBLUE}------------------------------------${NONE}"
else
output
ifacestatus
monitorstatus
dependenciesstatus
e "${GREEN}Compatible Linux Distrobution${NONE}"
e "${LBLUE}------------------------------------${NONE}"
fi
}
#dns established
dns_established() {
dns="valid"
}
#check if dns can be established
check_dns() {
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
dns_established
fi
}
dnsstatus() {
if [ "${dns}" == "valid" ]; then
e "${GREEN}DNS Connection Established${NONE}"
else
e "${LRED}DNS Could not be Established${NONE}"
fi
}
#display for check if dns can be established
display_check_dns() {
check_dns 
e "${LRED}Checking for DNS connection..${NONE}"
sleep 1.4
e "${LRED}Attempting to Connect..${NONE}"
sleep 1.3
if [ "${dns}" == "valid" ]; then
e "${GREEN}DNS Connection Established${NONE}"
else
e "${LRED}DNS Could not be Established${NONE}"
fi
clear
if [ "${dns}" == "valid" ]; then
output
ifacestatus
monitorstatus
dependenciesstatus
distrostatus
e "${GREEN}DNS Connection Established${NONE}"
e "${LBLUE}------------------------------------${NONE}"
else
output
ifacestatus
monitorstatus
dependenciesstatus
distrostatus
e "${LRED}DNS Could not be Established${NONE}"
e "${LBLUE}------------------------------------${NONE}"
fi
}
#check if user is root
check_permission() {
isroot=$(whoami)
if [ "${isroot}" == "root" ]; then
perm="valid"
fi
}
#display for check if user is root
display_check_permission() {
check_permission 
e "${LRED}Checking if user is root${NONE}"
sleep 1.4
if [ "${perm}" == "valid" ]; then
e "${GREEN}User is root user${NONE}"
else
e "${LRED}User is not root make sure to run as root${NONE}"
fi
clear
if [ "${perm}" == "valid" ]; then
output
ifacestatus
monitorstatus
dependenciesstatus
distrostatus
dnsstatus
e "${GREEN}User is root user${NONE}"
e "${LBLUE}------------------------------------${NONE}"
else
output
ifacestatus
monitorstatus
dependenciesstatus
distrostatus
dnsstatus
e "${LRED}User is not root make sure to run as root${NONE}"
e "${LBLUE}------------------------------------${NONE}"
fi
}

troubleshoot() {
display_check_interface
display_check_monitor
display_check_dependencies
display_check_distro
display_check_dns
display_check_permission
}

troubleshoot
