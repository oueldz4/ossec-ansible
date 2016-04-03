
Presentation 
============

OSSEC is an open source Host-Based Intrusion Detection Sytem (HIDS). It's one of the most used HIDS due to its ease of installation and use.

Among its features : 
* Monitoring and analyzing logs in real time. 
* File integrity checking.
* Rootkits detection (based on a list of signatures).
* Active-Response. 

Provisioning modes
==================

Ansible and Vagrant(for test mode) are used to do the virtualization and provisioning in Devops way.

Test mode provisioning
----------------------

You **should** first test the package in a Vagrant environment to ensure that everything will work well in your real and existing environment.

##### Prerequisites  
* Vagrant >= 1.7.4

##### Virtualization, provisiong and installation 

```bash
git clone https://github.com/oueldz4/ossec-ansible.git
cd ossec-ansible/provisioning
vagrant up 
```

Four Linux vms (one for provisioning, two OSSEC agents and one OSSEC server) and one Windows vm (OSSEC agent) will be created. 

Rmq: 
The downloading of the Windows box may take some time, so if you would like to test only in linux env, you can then comment the windows part in the Vagrantfile

Once terminated, you should access the OSSEC server on http://192.168.33.100:5601/ and create your first index (click on create). Then you will have to import the dashboards file located in **provisioning/roles/ossec-server/files/dashboard.json**. This is done with the use of ELK stack (Elasticsearch Logstash Kibana).


Provisioning on real machines (existing environment)
----------------------------------------------------

The provisioning should be done from a linux machine.

##### Prerequisites 
* Ansible 2.0.1
* Python 2.7
* Sshpass
* pip --> pip install xmltodict pywinrm

#### Configuration 

The hosts (agents and server) to provision should be declared in the **hosts** file.
> On linux, the chosen ssh user for the provisioning should be in sudoers group (to have rights to update and install packages).

> On Windows, the chosen user for the provisiong should be in admins group (Domain admin for example).

Next, the format of the hosts file: 

```ansible
[ossec_servers]
@IP_ossec_server

[ossec_server:vars]
ansible_ssh_user=ossec_server_username
ansible_ssh_user=ossec_server_password

[ossec_linux_agents]
@IP_ossec_linux_agent1
@IP_ossec_linux_agent2

[ossec_linux_agents:vars]
ansible_ssh_user=ossec_linux_agent_username
ansible_ssh_user=ossec_linux_agent_password

[ossec_windows_agents]
@IP_ossec_windows_agent

[ossec_windows_agents:vars]
ansible_ssh_user=ossec_windows_agent_username
ansible_ssh_pass=ossec_windows_agent_password
ansible_ssh_port=5986
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
ansible_winrm_transport=ssl
```

You will have to change the IP address of the OSSEC server in ** all** file which can be found in **provisioning/group_vars**
```
ossec_server: @IP_ossec_server
```

On Windows Environment, you should ensure that : 

- The hosts to provision are reachable. 
- The OSSEC server is reachable on port 1514 (if there is a FW, open that port).
- Winrm is installed on the machines to provision. Elsewhere, you should upgrade PowerShell (version >= 4.0) on the machines and execute the given script **ConfigureRemotingForAnsible.ps1** which can be found in **src** repository. It will install Winrm and open the port 5985 and 5986 to allow Ansible to communicate with the machines. If the script execution returns an error, you will have then to execute the PS command **Set-ExecutionPolicy Unrestricted**.

Next, we go to **ossec-ansible/provisioning** and lauch the magical command for the provisioning : 

```bash
ansible-playbook -i hosts playbook.yml
```

Once finished, you should go to your server IP address (http://@IP_ossec_server:5601) and import as well dashboards file present in **provisioning/roles/ossec-server/files/dashboard.json**.


To go further...
================

- Customize generated keys function
- Add and curtomize rules and dashboards
- And much more things to customize...


Please feel free to ping me on #ossec irc.freenode.net or [@oueldz4](https://twitter.com/oueldz4) 

