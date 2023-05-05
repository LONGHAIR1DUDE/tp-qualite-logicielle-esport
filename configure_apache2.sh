#!/bin/bash

# Replace the following variables with your own values
PROJECT_DIRECTORY="/home/site/wwwroot/"
PROJECT_DOMAIN="esport-staging.azurewebsites.net"

# Install Apache2 and PHP modules
apt update
apt install -y apache2 libapache2-mod-php php-mbstring php-xml

# Configure the Apache2 virtual host
cat <<EOF > /etc/apache2/sites-available/${PROJECT_DOMAIN}.conf
<VirtualHost *:80>
    ServerName ${PROJECT_DOMAIN}
    ServerAlias www.${PROJECT_DOMAIN}
    DocumentRoot ${PROJECT_DIRECTORY}/public
    <Directory ${PROJECT_DIRECTORY}/public>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/${PROJECT_DOMAIN}_error.log
    CustomLog \${APACHE_LOG_DIR}/${PROJECT_DOMAIN}_access.log combined
</VirtualHost>
EOF

# Enable the virtual host
a2ensite ${PROJECT_DOMAIN}

# Disable the default virtual host
a2dissite 000-default

# Reload Apache2 to apply the changes
systemctl reload apache2

echo "Apache2 has been configured to serve your Symfony PHP project."
