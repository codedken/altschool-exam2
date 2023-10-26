#!/bin/bash

# Declaring Arguments
USER_NAME=$1
PASS=$2
DATABASE_NAME=$3

# ==================================================================
# INSTALLATION AND DEPLOYMENT OF LAMP STACK (Linux Apache MySQL PHP)
# ==================================================================
echo "Installation of LAMP stack started...."
sleep 10

sudo apt-get install apache2 -y < /dev/null

sudo apt-get install mysql-server -y < /dev/null

sudo add-apt-repository -y ppa:ondrej/php < /dev/null

sudo apt-get update < /dev/null

sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y

sudo sed -i "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/8.2/apache2/php.ini

sudo systemctl restart apache2 < /dev/null

echo "Installation of LAMP stack completed successfully +++"
sleep 10



# ================================================================================
# CLONING A PHP APPLICATION FROM GITHUB AND INSTALLATION OF ALL NECESSARY PACKAGES
# ================================================================================
echo "Clonining of PHP application started...."
sleep 10

sudo apt-get install -y git

cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git

sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod 777 /var/www/html/laravel
sudo chmod 777 /var/www/html/laravel/storage
sudo chmod 777 /var/www/html/laravel/bootstrap/cache

cd laravel 

curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar /usr/local/bin/composer

composer --version < /dev/null

composer install --no-dev < /dev/null

cp .env.example .env

sudo sed -i "s/DB_DATABASE=laravel/DB_DATABASE=$DATABASE_NAME/g" /var/www/html/laravel/.env
sudo sed -i "s/DB_USERNAME=root/DB_USERNAME=$USER_NAME/g" /var/www/html/laravel/.env
sudo sed -i "s/DB_PASSWORD=/DB_PASSWORD=$PASS/g" /var/www/html/laravel/.env



echo "Cloning of PHP application completed successfully +++"
sleep 10



# ==================================
# CONFIGURATION OF APACHE WEB SERVER
# ==================================
echo "Apache config started...."
sleep 10

sudo touch /etc/apache2/sites-available/laravel.conf

sudo chmod 777 /etc/apache2/sites-available/laravel.conf

cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin cbsmoothoj@gmail.com
    ServerName 192.168.33.10
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2enmod rewrite
sudo a2ensite laravel.conf
sudo systemctl restart apache2

echo "Apache config completed successfully +++"
sleep 10



# ===================
# MySQL CONFIGURATION
# ===================
echo "MySQL config started...."
sleep 10

if [ -z "$2" ]; then
    PASS=`openssl rand -base64 8`
fi

sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $DATABASE_NAME;
CREATE USER '$USER_NAME'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$USER_NAME'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user and database created."
echo "Username: $USER_NAME"
echo "Database: $DATABASE_NAME"
echo "Password: $PASS"

echo "MySQL config completed successfully +++"
sleep 10



# ==========================
# PHP KEY GENERATE COMMAND
# ==========================
echo "PHP key generate started..."
sleep 10

cd /var/www/html/laravel && php artisan key:generate
cd /var/www/html/laravel && php artisan config:cache
cd /var/www/html/laravel && php artisan migrate

echo "PHP key generate completed successfully +++"
sleep 10