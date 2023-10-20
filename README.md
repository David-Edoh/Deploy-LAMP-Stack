# Laravel/LAMP Deployment Using Vagrant, Ansible, And Bash Scripting
<img src="https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/7e2aa977-08a0-4a0b-a0c9-959ebcb55cf4" align="center" height="300" width="450" >

This repository contains bash scripts and an Ansible playbook to automate the deployment of a Laravel application with LAMP stack on two virtual machines, a master, and a slave VM using Vagrant, VirtualBox, and Ansible.
The script will create and configure the two VMs using Vagrant, set up SSH key-based authentication, and execute the `setup_laravel_lamp.sh` script to setup Laravel and LAMP stack on the master node. The script also uses Ansible on the master VM to setup Laravel and LAMP stack on the slave VM by copying the `setup_laravel_lamp.sh` script to the slave and executing it.
## Prerequisites

Before using these automation scripts, make sure you have the following software installed on your local machine:

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/)

## Getting Started

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/David-Edoh/Deploy-LAMP-Stack.git && cd Deploy-LAMP-Stack
    ```

2. Run the deployment script to set up the master and slave VMs:

    ```bash
    chmod +x deploy_lamp_vms.sh && ./deploy_lamp_vms.sh
    ```

3. The master and slave VM would be created and Laravel/Lamp stack installed and configured. both VM's uptime will be logged daily at midnight. A success message would be displayed when the deployment is complete with the relevant links to access the laravel application on both VMs.

![access_app](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/f92bd588-6a6a-417c-ba73-193ffb9f9c3f)

## Accessing the Laravel Application

Once the deployment is complete, you can access the Laravel application using the following URLs:

- Master VM: http://192.168.56.5/
- Slave VM: http://192.168.56.6/

![master_proof](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/cc5a1b81-d157-457a-938d-2876f1704874)
![slave_proof](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/10139458-9325-4b68-8fc9-5308f8bca152)

## Database setup
The Application's database and tables would also be created and the relevent migrations done by the script.

![Screenshot from 2023-10-20 04-53-51](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/921aa5d3-272e-4bdc-91c8-b384499f18e0)

## Scripts/Playbook Information
1. `setup_laravel_lamp.sh`

    This script automates the deployment of a Laravel application on a virtual machine. Here's what it does:
    
    - Updates the system and installs necessary packages.
    - Installs PHP 8.2, Apache, MySQL (MariaDB), and Git.
    - Sets up MySQL root password and creates a database.
    - Installs Composer for Laravel.
    - Sets up Apache, clones the Laravel application from GitHub, and installs Composer dependencies.
    - Configures the `.env` file for the Laravel application.
    - Configures a virtual host for Apache.
    - Enables the Laravel site and disables the default Apache site.
    - Reloads Apache to apply changes.
    - Runs database migrations.

2. Ansible Playbook: `playbook.yaml`

    The Ansible playbook (`playbook.yaml`) is used to set up LAMP and deploy the Laravel application on the slave VM. Here's what it does:
    
    - Copies the `setup_laravel_lamp.sh` script to the slave VM.
    - Executes the script on the slave VM.
    - Sets up a cron job to check the server's uptime daily at midnight and logs the result.

## Troubleshooting

If you encounter issues during the deployment process, you can:
- Verify that both master and slave VMs are running.
  ![Screenshot from 2023-10-20 04-22-10](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/b8d00ab4-df31-4c49-be0e-7f015bcf5a9c)

- Check the log files created during the deployment for errors.
- Inspect the `setup_laravel_lamp.sh` script for any configuration issues.
- To stop and destroy the VMs, run `vagrant destroy`

## Conclusion

This repository provides a set of automation scripts to simplify the deployment of a Laravel application on multiple virtual machines with LAMP stack installed and configured. The use of Vagrant and Ansible ensures a consistent and reproducible deployment process.

For more information on Vagrant and Ansible, consult their documentation:

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)

Feel free to modify and adapt these scripts to your specific deployment needs.
