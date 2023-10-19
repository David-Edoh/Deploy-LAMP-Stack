#!/bin/bash

# variables
box_name="ubuntu/focal64"
master_vm="master"
slave_vm="slave"
vm_memory="2048"

master_ip="192.168.56.5"
slave_ip="192.168.56.6"

setup_directory="apache_laravel_setup"
laravel_setup_script="automate_laravel_deployment.sh"

# install vagrant copy plugin
vagrant plugin install vagrant-scp

# Create a Vagrantfile
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|

  # Master Server
  config.vm.define "$master_vm" do |master|
    master.vm.box = "$box_name"
    master.vm.network "private_network", type: "static", ip: "$master_ip"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "$master_vm"
      vb.memory = "$vm_memory"
      vb.cpus = 1
    end

    # Install Ansible on the master
    master.vm.provision "shell", inline: "sudo apt-get update"
    master.vm.provision "shell", inline: "sudo apt-get install -y ansible"

    # Switch to the vagrant user and generate SSH keys
    master.vm.provision "shell", inline: "su - vagrant -c 'ssh-keygen -t rsa -N \"\" -f ~/.ssh/ansible_id_rsa'"

    master.vm.provision "shell", inline: "echo 'This is the Master Server'"
  end

  # Slave Server
  config.vm.define "$slave_vm" do |slave|
    slave.vm.box = "$box_name"
    slave.vm.network "private_network", type: "static", ip: "$slave_ip"
    slave.vm.provider "virtualbox" do |vb|
      vb.name = "$slave_vm"
      vb.memory = "$vm_memory"
      vb.cpus = 1
    end
    slave.vm.provision "shell", inline: "echo 'This is the Slave Server'"
  end
end
EOF

# Initialize and start the virtual machines
vagrant up

# Copy Master's public key to the Slave VM
echo "Copying $master_vm public key to $slave_vm"
master_public_key=$(vagrant ssh $master_vm -c "sudo su - vagrant -c 'cat ~/.ssh/ansible_id_rsa.pub'")
vagrant ssh $slave_vm -c "echo '$master_public_key' | sudo su - vagrant -c 'tee -a ~/.ssh/authorized_keys'"
echo "SSH key-based authentication configured."

# Copy and run script for deploying apache, php and laravel to master
vagrant scp ./$laravel_setup_script $master_vm:~/$laravel_setup_script
vagrant ssh $master_vm -c "chmod +x ~/$laravel_setup_script && ~/$laravel_setup_script"

# Copy Ansible setup files to the Master VM
echo "Copying Ansible directory to $master_vm"
vagrant ssh $master_vm -c "rm -rf ~/$setup_directory"
vagrant scp ./$setup_directory $master_vm:~/
echo "Ansible directory copied to $master_vm."

# Copy script for deploying apache, php and laravel to slave
vagrant scp ./$laravel_setup_script $master_vm:~/$setup_directory/$laravel_setup_script

# Run Ansible playbook from the Ansible directory
echo -e "\nRunning Ansible playbook To set up LAMP/LLARAVEL on the slave VM"
vagrant ssh $master_vm -c "cd ~/$setup_directory && ansible-playbook ./playbook.yaml"

GREEN=$(tput setaf 2)
echo -e "${GREEN}""
###############################################
#           Deployment Successful             #
############################################### \n"

echo "Laravel app details"
echo "Visit: http://$master_ip/ to test the Laravel deployment on Master VM"
echo "Visit: http://$slave_ip/ to test the Laravel deployment on Slave VM"

