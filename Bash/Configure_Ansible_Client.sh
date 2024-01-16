#!/bin/bash
# This script will create a remote user and configure passwordless for it.
# By running this as Ansible admin user, you can configure the remote machine as Ansible client.
# After running the script, all you have to do for the Ansible client configuration is add the remote machine IP/hostname to the Ansible inventory.

read -p "Enter a username:" username
read -sp "Enter a password:" password

pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

[[ ! -f ~/.ssh/id_rsa ]] && [[ ! -f ~/.ssh/id_rsa.pub ]] && ssh-keygen -t rsa -b 4096 -C "Ansbile admin user"


read -p $'\n'"Enter a remote machine which need to be configured as ansible client(adminuser@machine_ip;ex: admin@10.1.1.5):" credentials

ip=$(echo "$credentials" | cut -d@ -f2)
ssh $credentials "sudo useradd -G sudo -p "$pass" -d "/home/$username" -m $username"

if [[ ! $credentials = *'@'* ]]; then
 echo -e "\n Incorrect remote details...\n Please startover and enter the remote machine details in the correct format: adminuser@remoteip or adminuser@remotehostname"
 exit
fi

sudo ssh-copy-id -i ~/.ssh/id_rsa.pub $username@$ip

echo "Please do remember to add the remote machine IP/hostname to the Ansible Inventory!\n Happy Automation :)"