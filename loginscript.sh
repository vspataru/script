#!/bin/bash
#######New user creation##################
#echo "Starting initial configuration script"
#echo "Please insert a usernname:" 
#read username
#sudo useradd -m $username
#echo "Please set the password for the newly created user: "
#sudo passwd $username

#######OS upgrade and install of packages#########################
distro=$(sudo cat /etc/*-release | grep NAME* -w -i | cut -d'"' -f2)
echo "Upgrading OS..."
if [[ $distro == "Ubuntu" ]]; then
sudo apt-get upgrade -qq -y > /dev/null
sudo apt-get update -qq -y > /dev/null
echo "DONE"
echo "Installing default packages..." 
sudo apt-get install apache2 -qq -y > /dev/null 
sudo apt-get install nginx -qq -y > /dev/null 
echo "DONE"
echo "OS upgrade and update done"
elif [[ $distro == "Red-Hat" ]]; then 
sudo yum update -qq -y > /dev/null
echo "DONE" 
echo "Installing default packages..."
sudo yum install apache2 -qq -y > /dev/null
sudo yum install nginx -qq -y > /dev/null
echo "DONE" 
echo "OS upgrade and update done" 
fi
#########Checker service creation############
cd /etc/systemd/system
sudo touch checker.service
sudo tee checker.service > /dev/null <<EOT
[Unit]
Description="Service used to check vital services on startup"

[Service]
User=vspataru
WorkingDirectory=/home/vspataru/login
ExecStart=checker.sh
Restart=always
[Install]
WantedBy=multi-user.target
EOT
sudo systemctl start checker.service
sudo systemctl enable checker.service