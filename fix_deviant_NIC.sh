#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Colors
green='\033[0;32m'
red='\033[0;31m'
plain='\033[0m'

d_file="/etc/init.d/fix_NIC_debian.sh"
d_file_url="https://git.io/fhJ6s"
c_file="/etc/rc.d/init.d/fix_NIC_redhat.sh"
c_file_url="https://git.io/fhJ6G"
hint="Install successfully, it can prevent you from losing network connection after recovery from snapshot! "

# CheckRoot
[ $(id -u) != "0" ] && { echo -e "[${red}Error${plain}] You must run me as a root! "; exit 1; }

# Judge OS
if [ -f /etc/redhat-release ];then
        OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep -i 'bian'`" ];then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep -i 'buntu'`" ];then
        OS='Ubuntu'
    else
        echo -e "We do not support current system, fix will exit!"
        exit 1
fi

# Disable SELinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

Write_apt_task() {
    if ! wget ${d_file_url} -O ${d_file}; then
        echo -e "[${red}Error${plain}] Downloading ${d_file} failed!"
        exit 1
    fi
    chmod 775 ${d_file}
    update-rc.d fix_NIC_debian.sh defaults 60
}

Write_yum_tast() {
    if ! wget ${c_file_url} -O ${c_file}; then
        echo -e "[${red}Error${plain}] Downloading ${c_file} failed!"
        exit 1
    fi
    chmod 775 ${c_file}
    chkconfig --add fix_NIC_redhat.sh
    chkconfig fix_NIC_redhat.sh on
}

if [[ ${OS} == 'Debian' ]] || [[ ${OS} == 'Ubuntu' ]]; then
    Write_apt_task
    echo -e "[${green}ok${plain}] ${hint}"
    rm $0
else
    Write_yum_task
    echo -e "[${green}ok${plain}] ${hint}"
    rm $0
fi
