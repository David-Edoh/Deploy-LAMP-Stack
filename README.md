# Laravel/LAMP Deployment Automation Using Vagrant, Ansible, And Bash Scripting
<img src="https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/0034445c-967c-4603-832a-77ab028a4ea2" align="center" height="300" width="450" >

This repository contains bash scripts and an Ansible playbook to automate the deployment of a Laravel application with LAMP stack on two virtual machines, a master, and a slave VM using Vagrant, VirtualBox, and Ansible.

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
    chmod +x deploy_lamp_stack.sh && ./deploy_lamp_stack.sh
    ```

3. The script will create and configure two VMs using Vagrant, set up SSH key-based authentication, and execute the `automate_laravel_deployment.sh` script on the master node. The script also uses ansible on the master VM to setup Laravel and LAMP stack on the slave VM.

4. The Laravel application will be deployed on the master and slave VM, and the server's uptime will be logged daily at midnight.

![access_app](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/5aff2bdd-4ad5-4735-b4e4-f7539bf851c2)

## Accessing the Laravel Application

Once the deployment is complete, you can access the Laravel application using the following URLs:

- Master VM: http://192.168.56.5/
- Slave VM: http://192.168.56.6/

![master_proof](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/c9f8cb4f-0e46-4203-848a-8b80e70e73a1)
![slave_proof](https://github.com/David-Edoh/Deploy-LAMP-Stack/assets/45123163/a1090b8b-eaa3-435c-aad6-54acd3459513)

## Scripts/Playbook Information
1. `automate_laravel_deployment.sh`

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
    
    - Copies the `automate_laravel_deployment.sh` script to the slave VM.
    - Executes the script on the slave VM.
    - Sets up a cron job to check the server's uptime daily at midnight and logs the result.

## Troubleshooting

If you encounter issues during the deployment process, you can:
- To stop and destroy the VMs, run `vagrant destroy`
- Check the log files created during the deployment for errors.
- Inspect the `automate_laravel_deployment.sh` script for any issues.

## Conclusion

This repository provides a set of automation scripts to simplify the deployment of a Laravel application on multiple virtual machines with LAMP stack installed and configured. The use of Vagrant and Ansible ensures a consistent and reproducible deployment process.

For more information on Vagrant and Ansible, consult their documentation:

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)

Feel free to modify and adapt these scripts to your specific deployment needs.
