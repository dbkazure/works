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
 Playbook: 	~/playbooks/adhoc-tasks/user_group.yml\
 Role:		~/roles/user_group
 
----------------------------------------------

----------------------------------------------
Freezing Operating System to a particular release.
----------------------------------------------
 Use Case: 	Some applications requires the Operating System need to be permanently on a particular version.\
 Playbook: 	~/playbooks/adhoc-tasks/freeze_version.yml\
 Role:		~/roles/freeze_version\
 
----------------------------------------------

----------------------------------------------
Checking for the files with SETUID, SETGID and STICKYBIT set
----------------------------------------------
 Use Case: 	SETUID, SETGID and STICKYBIT can be an expolit if set wrongly or by mistake, so it should be verified.\
 Playbook: 	~/playbooks/adhoc-tasks/SUID_SGID_SBIT_check.yml\
 Role:		~/roles/SUID_SGID_SBIT_check
 
----------------------------------------------

----------------------------------------------
 Apply security patch on Servers
----------------------------------------------
 Use Case: 	Push a quick patch, especially a zero day vulnerability package.\
 Playbook: 	~/playbooks/adhoc-tasks/quick_patch.yml\
 Role:		~/roles/quick_patch
 
----------------------------------------------

----------------------------------------------
 Ensure a list of services are running
----------------------------------------------
 Use Case: 	Ensure Critical services are running.\
 Playbook: 	~/playbooks/adhoc-tasks/service_check.yml\
 Role:		~/roles/service_check
 
----------------------------------------------
HOW TO RUN:
--
Run the playbook which will initiate the respective role.\
$ ansible-playbook -i inventory/hosts playbooks/<playbook>.yml -K

Eg: To run Service_check role(Role#5 in the list)\
$ansible-playbook -i inventory/hosts playbooks/adhoc-tasks/service_check.yml -K


