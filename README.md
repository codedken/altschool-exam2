# ALTSCHOOL 2ND SEMESTER PROJECT FOR CLOUD ENGINEERING

## Project Objective

* Automate the provisioning of two Ubuntu-based servers, named "Master" and "Slave" using Vagrant.

  * On the Master Node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack.

    * This script should clone a PHP application from Github, install all necessary packages, and configure Apache web server and MySQL.
    * Ensure the bash script is reusable and readable

  * Using an Ansible playbook:
    * Execute the bash script on the Slave node and verify that the PHP application is accessible through the VM's IP address (take screenshot of this as evidence)
    * Create a cron job to check the server's uptime every 12am.

### Brief Summary of the Project

In summary, the project is all about the automation of two ubuntu-based VMs called Master and Slave using Vagrant. Using bash script to deploy a PHP (laravel) application on the Master node with LAMP stack installed. While using ansible to create a cron job to check server uptime every 12am and to automate the bash script on the Slave node from a control node (which is the Master node in this case).

#### Explaining the files & directories

**ansible:** This directory contains the following

* ansible.cfg file which holds the ansible configuration
* inventory file which holds the managed servers ips
* task.yml is the ansible playbook which holds the plays and tasks for creating the cron job and running the slave-script
* files directory. This holds the slave-script bash script that contains the configuration bash commands for LAMP installation and PHP (Laravel)application deployment on the Slave Node

**master-script:** This script contains the configuration commands for installing LAMP stack and deployment of the PHP (Laravel) application on the Master Node.

**vagrant-script:** This script is used for creating the Vagrantfile that holds the configuration program for provisioning the VMs, and to spin them up.

**README:** contains the project documentation

#### Master-script and Slave-script content

The master-script and slave-script contain commands for installing and configuring apache2, php, and mysql server. They also contain the program for installing and deployment of a PHP (Laravel) application.

Both the master-script and the slave-script contains the same thing except for their ip address which differs in the **/etc/apache2/sites-available/laravel.conf** file

#### IP Addresses

Slave Machine IP: ```192.168.33.10```
Master Machine IP: ```192.168.33.11```

#### Requirements for running application

* A good PC
* Code editor (vscode is cool)
* Virtual Box hypervisor
* Good Internet network connection
* A basic understanding of git is recommended
* ... and a great attitude of patience

#### Technologies used

* Vagrant
* Ansible
* Shell scripting

#### How to run the Master-script on the Master node or machine

1. Clone the repo into your local machine by typing ```git clone "paste the repo url here"``` using a CLI (gitbash is cool) and move to the cloned project using this command ```cd altschool-exam2```

2. To run the master-script on the master node, you need to spin it up by running ```./vagrant-script.sh``` and run ```vagrant ssh master``` to log into the master node. The script should be ran from the root user, log into the root account with this command ```sudo su -```

3. As a root user, run this ```cd /vagrant``` to access the altschool-exam2 directory contents.

4. To run the master-slave script, you have to make it executable by running this ```chmod +x master-slave.sh``` after which you now run the script with 3 arguments. ```./master-slave.sh "username" "password" "database name"``` for example ```./master-slave.sh codedken pass123 altschooldb```.

5. If it runs successfully, you will be able to test it by typing the ip address ```192.168.33.11``` on a browser and you will see the Laravel home page appear.

Congratulations.. You have successfully deployed a PHP (Laravel) application on the master node.

#### How to automate the slave-script on the Slave node using ansible from the Master node

1. Clone the repo into your local machine by typing ```git clone "paste the repo url here"``` using a CLI (gitbash is cool) and move to the cloned project using this command ```cd altschool-exam2```

2. Spin up the slave and master machines by running ```./vagrant-script.sh``` You can open two CLI windows with both pointing at the cloned altschool-exam2 directory and run ```vagrant ssh master``` on one and ```vagrant ssh slave``` on the other to log into the both nodes. On both CLIs, log into the root account with this command ```sudo su -```

3. On the Master node, you need to create ssh key using this command ```ssh-keygen``` and keep on clicking enter, after which you go to the ~/.ssh/id_rsa.pub file and copy its content using this command ```nano ~/.ssh/id_rsa.pub``` save the file by typing ctrl o, click enter and then ctrl x to exit the nano editor.

4. On the Slave node, open ~/.ssh/authorized_keys file with nano to paste the key you just copied from the master node. (follow step 3 to open the ~/.ssh/authorized_keys file)

5. You can test if the ssh key is working by typing ```ssh root@192.168.33.10``` This should take you to the slave machine from the master machine. Type ```logout``` to go back to the master machine.

6. To run the ansible script, ```cd ansible``` and run this command ```ansible-playbook -i inventory task.yaml --ask-vault-pass``` enter champion as the password

7. If it runs successfully, you will be able to test it by typing the ip address of the slave node ```192.168.33.10``` on a browser and you will see the Laravel home page appear.

Congratulations.. You have successfully deployed a PHP (Laravel) application on the slave node.

Thanks for trying it out. cheers 🥂

Screenshot of the laravel home page opened using the IP address of the Slave Machine

![Laravel Home Page](https://github.com/codedken/altschool-exam2/blob/main/laravel-home.png?raw=true)
