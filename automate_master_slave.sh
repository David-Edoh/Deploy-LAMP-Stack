#!/bin/bash

# variables
box_name="ubuntu/focal64"
master_vm="master"
slave_vm="slave"
vm_memory="2048"

# Create a Vagrantfile
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|

  # Master Server
  config.vm.define "$master_vm" do |master|
    master.vm.box = "$box_name"
    master.vm.network "private_network", type: "dhcp"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "$master_vm"
      vb.memory = "$vm_memory"
      vb.cpus = 1
    end

    master.vm.provision "shell", inline: "echo 'This is the Master Server'"
    
    # Copy the Laravel setup script to the /vagrant directory
    # master.vm.provision "file", source: "automate_laravel_deployment.sh", destination: "/vagrant/automate_laravel_deployment.sh"

    # Run the Laravel setup script
    # master.vm.provision "shell", inline: "bash /vagrant/automate_laravel_deployment.sh"
  end

  # Slave Server
  config.vm.define "$slave_vm" do |slave|
    slave.vm.box = "$box_name"
    slave.vm.network "private_network", type: "dhcp"
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

# Display information about the running virtual machines
vagrant status
