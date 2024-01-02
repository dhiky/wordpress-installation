#!/bin/bash

# Generate the User DB & Password
db_passwd="head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12"
db_user="wp_data$(printf '%02d' $((RANDOM % 100)))"
user_admin="wp_admin$(printf '%02d' $((RANDOM % 100)))"
user_passwd="head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8"

# Database for the Wordpress
echo "Preparing the Database for Wordpress..."


# Install the Wordpress
echo "Installing Wordpress..."
nginx_conf="/etc/nginx/conf.d/*"
doc_root="$(awk '$1 == "root" {print $2}' "$NGINX_CONF" | head -n 1 | tr -d ';')"
wp core download --path="$doc_root"
wp config create --dbname="$db_user" --dbuser="$db_user" --dbpass="$db_passwd" --path="$doc_root"
wp db create --path="$doc_root"
wp core install --url="http://bokunoweb.my.id" --title="Your Website" --admin_user="$user_admin" --admin_password="$user_passwd" --admin_email="dhiky.cancerio@gmail.com" --path="$doc_root"
