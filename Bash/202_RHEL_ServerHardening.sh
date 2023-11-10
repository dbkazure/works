#!/bin/bash

# Ensure firewall package is running and SSH is allowed.

clear
if [ ! $(sudo rpm -qa firewalld) ]; then
    echo -e "\n Firewalld not found! Installing it.. "
    sudo dnf install -y firewalld
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    sudo firewall-cmd --permanent --zone=public --add-service=ssh 2> /dev/null
    sudo firewall-cmd --reload
elif [ ! $(systemctl is-active --quiet firewalld) ]; then
    echo -e "\nFirewalld is not running.. Starting it and ensuring the SSH is allowed!"
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    sudo firewall-cmd --permanent --zone=public --add-service=ssh 2> /dev/null
    sudo firewall-cmd --reload
else
    echo -e "\nFirewall was already running, ensuring the SSH is allowed"
    sudo firewall-cmd --permanent --zone=public --add-service=ssh 2> /dev/null
    sudo firewall-cmd --reload
fi

echo -e "\n#####Print Allowed service(s) in each Zone#####\n"
Zonelist=( $(firewall-cmd --get-zones) )
for Zone in "${Zonelist[@]}";do
   echo "---------$Zone----------------"
   sudo firewall-cmd --zone $Zone --list-services
   echo "-----------------------------"
done

# Harden kernel parameters
#kernel.randomize_va_space controls Address Space Layout Randomization (ASLR), which can help defeat certain types of buffer overflow attack.
# kernel.dmesg_restrict restrict access to dmesg information which can contain sensitive info
# kernel.perf_event_paranoid disallow kernel profiling for unprivileged users
sysctl_settings=("kernel.randomize_va_space=2" "kernel.dmesg_restrict=1" "kernel.perf_event_paranoid=2")
for setting in "${sysctl_settings[@]}"; do
    echo "$setting" | sudo tee -a /etc/sysctl.d/90-kernel.conf > /dev/null
    sudo sysctl -p /etc/sysctl.d/90-kernel.conf
done

# Harden network parameters
net_settings=("net.ipv4.tcp_syncookies=1" "net.ipv4.conf.default.log_martians=1" "net.ipv4.conf.all.log_martians=1" "net.ipv4.conf.all.accept_source_route=0" "net.ipv4.conf.default.accept_source_route=0" "net.ipv6.conf.all.accept_source_route=0" "net.ipv6.conf.default.accept_source_route=0")
for setting in "${net_settings[@]}"; do
    echo "$setting" | sudo tee -a /etc/sysctl.d/90-net.conf > /dev/null
    sudo sysctl -p /etc/sysctl.d/90-net.conf
done

# Disable ip forwarding
ip_forward_settings=("net.ipv4.ip_forward=0" "net.ipv6.conf.all.forwarding=0")
for setting in "${ip_forward_settings[@]}"; do
    echo "$setting" | sudo tee -a /etc/sysctl.d/90-ip.conf > /dev/null
    sudo sysctl -p /etc/sysctl.d/90-ip.conf
done

# Disable ICMP echo and redirects
icmp_settings=("net.ipv4.icmp_echo_ignore_broadcasts=1" "net.ipv4.icmp_echo_ignore_all=1" "net.ipv4.conf.default.accept_redirects=0" "net.ipv4.conf.all.accept_redirects=0" "net.ipv6.conf.all.accept_redirects=0" "net.ipv6.conf.default.accept_redirects=0" "net.ipv4.conf.default.send_redirects=0" "net.ipv4.conf.all.send_redirects=0")
for setting in "${icmp_settings[@]}"; do
    echo "$setting" | sudo tee -a /etc/sysctl.d/90-icmp.conf > /dev/null
    sudo sysctl -p /etc/sysctl.d/90-icmp.conf
done

# Check and enable SELinux
SELINUX_STATUS=$(getenforce)
if [ "$SELINUX_STATUS" == "Enforcing" ]; then
  echo "SELinux is enabled"
elif [ "$SELINUX_STATUS" == "Permissive" ]; then
  echo "SELinux is permissive, changing it to Enforcing (Enabled state)"
  setenforce 1
  sudo sed -c -i "s/\SELINUX=.*/SELINUX=enforcing/" selinux
  echo "SELinux is in permissive mode, Enabling SELinux, please remember to RESTART the computer"
else
  echo "SELinux is disabled.. Enabling SELinux, please remember to RESTART the computer"
  sudo sed -c -i "s/\SELINUX=.*/SELINUX=enforcing/" selinux
fi

