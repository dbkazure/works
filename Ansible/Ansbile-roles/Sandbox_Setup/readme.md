# Ansible role to setup Sandbox Setup on Ubuntu.

This Ansible role will setup Chroot and Docker Image in Ubuntu, which can essentially be used as a Sandbox for testing.
VM setup has yet to be added, which is currently in the development stage.

To run the playbook or role:

ansible-playbook sandbox_setup.yml --tags Docker -K

ansible-playbook sandbox_setup.yml --tags Chroot -K

ansible-playbook sandbox_setup.yml --tags VM -K

Note: Please make sure to update the hosts entry with the destination machine hostname or IP.

--------------------------------------------------------

Desclamir: This Ansible role was setup as part of my plans to upskill on Ansible. Kindly review the code and make the necessary changes if you plan to test it in your own environment, especially on the security side.

--------------------------------------------------------
