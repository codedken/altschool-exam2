#!/bin/bash

vagrant init

cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |vm|
        vm.memory = "1024"
        vm.cpus = "2"
    end
    
    # Slave Server
    config.vm.define "slave" do |slave|
        slave.vm.box = "ubuntu/focal64"
        slave.vm.network "private_network", ip: "192.168.33.10"
        slave.vm.hostname = "slave"

        slave.vm.provision "shell", inline: <<-SHELL
            sudo apt-get update && sudo apt-get upgrade -y
            sudo apt-get install -y avahi-daemon libnss-mdns
            sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
        SHELL
    end

    # Master Server
    config.vm.define "master" do |master|
        master.vm.box = "ubuntu/focal64"
        master.vm.network "private_network", ip: "192.168.33.11"
        master.vm.hostname = "master"

        master.vm.provision "shell", inline: <<-SHELL
            sudo apt-get update && sudo apt-get upgrade -y
            sudo apt-get install -y avahi-daemon libnss-mdns
            sudo apt-get install -y ansible
        SHELL
    end
end
EOF

vagrant up

