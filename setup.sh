#!/bin/bash
mkdir config
cd config || exit
touch users.list # List all Regular users
sudo chmod 777 "users.list"
touch admins.list # List all Admin users
sudo chmod 777 "admins.list"
touch requiredApps.list # List all Required apps that shouldn't be removed
sudo chmod 777 "requiredApps.list"
touch general.conf #Check OS and other things required
sudo chmod 777 "general.conf"
cd ..
mkdir logs
cd logs
sudo touch latest.log
cd ..
echo Do you want to run the script now? [y/n]
read option

echo "$option"

if [[ "$option" == y ]]; then
    echo Starting Script
    bash ./scripts/main.sh
fi