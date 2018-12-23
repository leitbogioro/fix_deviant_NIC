#!/bin/bash

### BEGIN INIT INFO
# Provides:          molly lau
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: fix deviant NIC
# Description:       fix from deviant NIC deamon
### END INIT INFO

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Colors
green='\033[0;32m'
red='\033[0;31m'
plain='\033[0m'

# CheckRoot 
[ $(id -u) != "0" ] && { echo -e "[${red}Error${plain}] You must run me as a root! "; exit 1; }

# Disable SELinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

CurrentETH=`ifconfig -a | awk '{print $1}' | head -n 1`
ConfigETH=`cat /etc/network/interfaces | sed -n '$p'  | awk '{print $2}'`
Interface="/etc/network/interfaces"

# Check ping
IPLists="1.1.1.1 8.8.8.8 9.9.9.9"
result=0
PingStatus() {
    if ping -c 1 $IP > /dev/null; then
        result=`expr $result + 1`
        continue
    fi
    return $result
}
StartPing() {    
    for IP in $IPLists; do
        PingStatus
    done
}
StartPing

# WriteNIC
configETH() {
    rm -rf ${Interface}
    cat > ${Interface}<<-EOF
auto lo
iface lo inet loopback
auto ${CurrentETH}
iface ${CurrentETH} inet dhcp
EOF
    service networking restart
}

if [[ ! ${CurrentETH} == ${ConfigETH} ]] && [[ ! ${result} -lt 0 ]]; then
    configETH
    echo -e "[${green}Congratulations${plain}] Your fuckin network will be okay! "
else
    echo -e "[${green}Congratulations${plain}] Your network seems have no problem, No alternations need to be applied! "
    exit 1
fi
