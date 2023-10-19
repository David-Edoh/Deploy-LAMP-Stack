# Laravel/LAMP Deployment Automation Using Ansible And Bash Scripting

This repository contains bash scripts and an Ansible playbook to automate the deployment of a Laravel application with LAMP stack on two virtual machines, a master, and a slave VM using Vagrant, VirtualBox, and Ansible.

## Prerequisites

Before using these automation scripts, make sure you have the following software installed on your local machine:

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/)

## Getting Started

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/your-username/laravel-deployment-automation.git && cd laravel-deployment-automation
    ```

2. Run the deployment script to set up the master and slave VMs:

    ```bash
    chmod +x deploy_master_and_slave_nodes.sh && ./deploy_lamp_stack.sh
    ```

3. The script will create and configure two VMs using Vagrant, set up SSH key-based authentication, and execute the `automate_laravel_deployment.sh` script on the master and slave VM.

4. The Laravel application will be deployed on the master VM and the slave VM, and the server's uptime will be logged daily at midnight.

## `automate_laravel_deployment.sh`

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

## Ansible Playbook: `playbook.yaml`

The Ansible playbook (`playbook.yaml`) is used to set up LAMP and deploy the Laravel application on the slave VM. Here's what it does:

- Copies the `automate_laravel_deployment.sh` script to the slave VM.
- Executes the script on the slave VM.
- Sets up a cron job to check the server's uptime daily at midnight and logs the result.

## Troubleshooting

If you encounter issues during the deployment process, you can:

- Check the log files created during the deployment for errors.
- Inspect the `automate_laravel_deployment.sh` script for any issues.

## Conclusion

This repository provides a set of automation scripts to simplify the deployment of a Laravel application on multiple virtual machines. The use of Vagrant and Ansible ensures a consistent and reproducible deployment process.

For more information on Vagrant and Ansible, consult their documentation:

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)

Feel free to modify and adapt these scripts to your specific deployment needs.
