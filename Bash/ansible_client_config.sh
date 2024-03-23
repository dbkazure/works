#!/bin/bash
# This script will create a remote user and configure passwordless for it.
# By running this as Ansible admin user, you can configure the remote machine as Ansible client.
# After running the script, all you have to do for the Ansible client configuration is add the remote machine IP/hostname to the Ansible inventory.

read -p "Enter ansible username:" username

if [ ! -d ~/.ssh ]; then
        sudo mkdir ~/.ssh
fi

if [ ! -e ~/.ssh/id_rsa.pub ] || [ ! -e ~/.ssh/id_rsa ]; then
        echo -e "\n Just taking a backup of the ".ssh" directory so as not to mess around with any private key within"
        cp -R ~/.ssh ~/.ssh-`date +%Y%b%d`
        echo -e "\nKeys doesn't exists.. Generating new... \n"
        sudo ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -C "Ansbile admin user"

#pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

# Collect remote admin or root login details..
read -p "Enter remote admin login details(adminuser@machine_ip;ex: admin@10.1.1.5):" credentials
if [[ ! $credentials = *'@'* ]]; then
 echo -e "\n Incorrect remote details...\n Please startover and enter the remote machine details in the correct format: adminuser@remoteip or adminuser@remotehostname"
 exit
fi

# Check and confirm the sudo group for having elevate privilege.
 if [ $(ssh $credentials "getent group wheel") ];then
    sudogroup='wheel'
 else [ $(ssh $credentials "getent group sudo") ]
    sudogroup='sudo'
fi
echo "Sudo group is: $sudogroup"


#ip=$(echo "$credentials" | cut -d@ -f2)
ssh $credentials "sudo useradd -G '$sudogroup' -d '/home/$username' -m $username"
sudo scp ~/.ssh/id_rsa.pub $credentials:/tmp/
ssh $credentials "sudo mkdir /home/$username/.ssh && sudo chown $username:$username /home/$username/.ssh; \
        sudo cat /tmp/id_rsa.pub | sudo tee -a /home/$username/.ssh/authorized_keys && sudo chmod 600 /home/$username/.ssh/authorized_keys; \
        sudo chown -R $username:$username /home/$username/.ssh/"

if [ $? -ne 0 ];then
    echo "Looks like password authentication is not enabled on the remote machine, let try with ssh keys..."
    read -p "Enter the remote admin private key file [/etc/ansible/userkeys/admin/id_rsa]:" key
    if [ $key == ""];then
            key="/etc/ansible/userkeys/admin/id_rsa"
    fi
    # Check and confirm the sudo group for having elevate privilege.
    if [ $(ssh -i $key $credentials "getent group wheel") ];then
      sudogroup='wheel'
    else [ $(ssh -i $key $credentials "getent group sudo") ]
      sudogroup='sudo'
    fi
    echo "Sudo group is: $sudogroup"
    ssh -i $key $credentials "sudo useradd -G '$sudogroup' -d '/home/$username' -m $username"
    sudo scp -i $key ~/.ssh/id_rsa.pub $credentials:/tmp/
    ssh -i $key $credentials "sudo mkdir /home/$username/.ssh && sudo chown $username:$username /home/$username/.ssh; \
                sudo cat /tmp/id_rsa.pub | sudo tee -a /home/$username/.ssh/authorized_keys && sudo chmod 700 /home/$username/.ssh/authorized_keys; \
               sudo chown -R $username:$username /home/$username/.ssh"
fi

if [ $? -eq 0 ]; then
    echo "\n Client setup is done! Please do remember to add the remote machine IP/hostname to the Ansible Inventory!\n Happy Automation :)"
else
    echo "Something went wrong please see previous errors"
fi
