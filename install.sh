#!/bin/bash

# Generate the User DB & Password
db_passwd="cat /dev/urandom | tr -dc '[:alnum:]!@#$%^&*()' | head -c 12"
db_user="wp_data$(printf '%02d' $((RANDOM % 100)))"
user_admin="wp_admin$(printf '%02d' $((RANDOM % 100)))"
user_passwd="cat /dev/urandom | tr -dc '[:alnum:]!@#$%^&*()' | head -c 10"

# Database for the Wordpress
echo "Preparing the Database for Wordpress..."
mysql -u root -p'$ROOT_PASSWD' <<EOF
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_passwd';
FLUSH PRIVILEGES;
EOF

# Install the Wordpress
echo "Installing Wordpress.."
doc_root="$(sed -n -e '/^\s*root\s*/{s/^\s*root\s*//;s/;//p}' /etc/nginx/conf.d/*.conf)"
wp core download --path=$doc_root
wp config create --dbname=$db_user --dbuser=$db_user --dbpass=$db_passwd --path=$doc_root
echo "Creating Database for Wordpress..."
wp db create --path=$doc_root
mysql -u root -p'${{ secrets.ROOT_PASSWD }}' <<EOF
GRANT CREATE, SELECT, INSERT, UPDATE, DELETE ON $db_user.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
EOF
wp core install --url="http://bokunoweb.my.id" --title="Your Website" --admin_user=$user_admin --admin_password=$user_passwd --admin_email=dhiky.cancerio@gmail.com --path=$doc_root
echo "We are successfully installing the Wordpress, Please use this Creds and login on your web."
echo "Link : http://bokunoweb.my.id/wp-admin"
echo "User : $user_admin"
echo "Pass : $user_passwd"
echo "I'm suggesting you to change the Admin Password for security concern / Download plugin 2FA for extra authentication."
