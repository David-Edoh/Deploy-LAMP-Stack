#!/bin/bash


# variables
mysql_root_password="HQtKNYBdwhHJ"
laravel_db="laravel_db"

# Update the package list and upgrade the system
sudo apt update
sudo apt upgrade -y

# install PHP version 8.2
sudo apt install -y lsb-release gnupg2 ca-certificates apt-transport-https software-properties-common
echo | sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y php8.2 php8.2-mysql php8.2-curl php8.2-xml php8.2-zip zip unzip 

# Install Apache, MySQL (MariaDB), and other required packages
sudo apt install -y apache2 mariadb-server git

# Set the MySQL root password and create database
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysql_root_password';
CREATE DATABASE $laravel_db;
EOF

# install composer for Laravel
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer

# Increase PHP memory limit for the duration of the composer install
sudo sed -i 's/memory_limit = .*/memory_limit = -1/' /etc/php/8.2/apache2/php.ini

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

composer clearcache 
composer selfupdate


# Create and Change the ownership of the Laravel directory
sudo mkdir -p /var/www/laravel
sudo chown -R www-data:www-data /var/www/laravel

# Clone the Laravel application from GitHub
sudo -u www-data git clone https://github.com/laravel/laravel.git /var/www/laravel

# Navigate to the Laravel app directory
sudo chown -R "$USER" /var/www/laravel
cd /var/www/laravel || exit

# Install Composer dependencies with increased memory limit
php -d memory_limit=-1 /usr/bin/composer install

# Restore the original PHP memory limit
sudo sed -i 's/memory_limit = -1/memory_limit = 128M/' /etc/php/8.2/apache2/php.ini

# Create a .env file
cp .env.example .env

# Update the .env file with the database connection settings
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=$laravel_db/g" /var/www/laravel/.env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=$mysql_root_password/g" /var/www/laravel/.env

# Generate an application key
php artisan key:generate

# Create a virtual host configuration for Apache
sudo tee /etc/apache2/sites-available/laravel.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/laravel/public

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/laravel/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Enable the Laravel site and disable the default Apache site
sudo a2ensite laravel
sudo a2dissite 000-default

# Reload Apache to apply changes
sudo systemctl reload apache2

# migrate database and tables
php artisan migrate

# Display installation completed message
echo "Laravel application has been deployed and configured successfully!"
echo "Make sure to configure your MySQL database settings in the .env file."

