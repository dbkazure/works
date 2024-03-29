Ansible Roles
--

Contents: This contains Ansible roles to automate certain Linux Administration tasks. I will be updating more roles to this repository so please do keep watching it.

List of Roles:\
#Role1 : Creating Users and Groups, and users to groups.\
#Role2 : Freezing Operating System to a particular release.\
#Role3 : Checking for the files with SETUID, SETGID and STICKYBIT set\
#Role4 : Apply security patch on Servers\
#Role5 : Ensure a list of services are running

----------------------------------------------
 Creating Users and Groups, and users to groups.
----------------------------------------------
Use Case: 	Any environment you will need to have list of default users in all systems.\
Playbook: 	~/Ansible-roles/user_group.yml\
Role:		~/Ansible-roles/user_group

How to run this role: $ansible-playbook -i ~/Ansible-roles/user_group.yml -K\
 
 ----------------------------------------------

----------------------------------------------
Freezing Operating System to a particular release.
----------------------------------------------
Use Case: 	Some applications requires the Operating System need to be permanently on a particular version.\
Playbook: 	~/Ansible-roles/freeze_version.yml\
Role:		~/Ansible-roles/freeze_version\

How to run this role: $ansible-playbook -i ~/Ansible-roles/freeze_version.yml -K\
 
----------------------------------------------

----------------------------------------------
Checking for the files with SETUID, SETGID and STICKYBIT set
----------------------------------------------
Use Case: 	SETUID, SETGID and STICKYBIT can be an expolit if set wrongly or by mistake, so it should be verified.\
Playbook: 	~/Ansible-roles/SUID_SGID_SBIT_check.yml\
Role:		~/Ansible-roles/SUID_SGID_SBIT_check

How to run this role: $ansible-playbook -i ~/Ansible-roles/SUID_SGID_SBIT_check.yml -K\
 
----------------------------------------------

----------------------------------------------
 Apply security patch on Servers
----------------------------------------------
Use Case: 	Push a quick patch, especially a zero day vulnerability package.\
Playbook: 	~/Ansible-roless/quick_patch.yml\
Role:		~/Ansible-roles/quick_patch

How to run this role: $ansible-playbook -i ~/Ansible-roless/quick_patch.yml -K\
 
----------------------------------------------

----------------------------------------------
 Ensure a list of services are running
----------------------------------------------
Use Case: 	Ensure Critical services are running.\
Playbook: 	~/Ansible-roles/service_check.yml\
Role:		~/Ansible-roles/service_check
 
How to run this role: $ansible-playbook -i ~/Ansible-roles/service_check.yml -K\

----------------------------------------------
SandboxSetup
----------------------------------------------
Use Case: Sandbox environments are typically useful to test a suspicious code.\
Playbook: 	~/Ansible-roles/Sandbox_Setup/sandbox/sandbox_setup.yml\
Role:		~/Ansible-roles/Sandbox_Setup/sandbox/
 
How to run this role: $ansible-playbook -i ~/Ansible-roles/Sandbox_Setup/sandbox/sandbox_setup.yml -K\

----------------------------------------------
 
----------------------------------------------
HOW TO RUN a role:
--
Run the playbook which will initiate the respective role.\
$ ansible-playbook -i inventory/hosts playbooks/<playbook>.yml -K

Eg: To run Service_check role(Role#5 in the list) the respective playbook to intiate is service_check.yml\
$ansible-playbook -i inventory/hosts playbooks/adhoc-tasks/service_check.yml -K


