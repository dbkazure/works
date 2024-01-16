# Ansible role to setup Sandbox Setup on Ubuntu.

This Ansible role will setup Chroot and Docker Image in Ubuntu which essentailly can be used as Sandbox for testing.
VM setup yet to be added which is currently in development stage.

To run the playbook/role.

ansible-playbook sandbox_setup.yml --tags Docker -K
ansible-playbook sandbox_setup.yml --tags Chroot -K
ansible-playbook sandbox_setup.yml --tags VM -K

Note: Please make sure to update the hosts entry with destination machine hostname/IP.
--------------------------------------------------------
Desclamir: This Ansible role was setup as part of my plans to upskill on Ansible. Kindly review the code and make necessary changes if you plan to test it in your own environment(especailly on the security side).
--------------------------------------------------------
