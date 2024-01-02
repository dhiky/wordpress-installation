#!/bin/bash

# Tell to the script if the command / software is available from VPS
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# If command "wp" is not available, Install the wp-cli.
if command_exists "wp"; then
  echo "wp-cli is already installed."
else
  echo "Installing wp-cli..."
  # Install wp-cli
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp
  echo "wp-cli installed successfully."
fi

# If command "composer" is not available, Install the Composer.
if command_exists "composer"; then
  echo "Composer is already installed."
else
  echo "Installing Composer..."
  # Install Composer
  EXPECTED_CHECKSUM="$(curl -s https://composer.github.io/installer.sig)"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php --quiet
  rm composer-setup.php
  sudo mv composer.phar /usr/local/bin/composer
  echo "Composer installed successfully."
fi
