#!/bin/bash
#######New user creation##################
echo "Starting initial configuration script"
echo "Please insert a usernname:" 
read username
sudo useradd -m -G root $username
echo "Please set the password for the newly created user: "
sudo passwd $username

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
echo "Creating checker service"
mkdir ~/scripts
touch ~/scripts/checker.sh
sudo tee ~/errors/checker.sh > /dev/null <<EOT
#!/bin/bash
while :
do
if [[ $(systemctl is-active rsyslog.service)!='active' ]]; then
systemctl start rsyslog.service
fi

if [[ $(systemctl is-active cron.service)!='active' ]]; then
systemctl start cron.service
fi
sleep 30;
done
EOT
sudo touch /etc/systemd/system/checker.service
sudo tee /etc/systemd/system/checker.service > /dev/null <<EOT
[Unit]
Description="Service used to check vital services on startup"

[Service]
Type=simple
Restart=on-failure
RestartSec=10
ExecStart=/bin/bash ~/scripts/checker.sh
User=root

[Install]
WantedBy=multi-user.target
EOT
sudo systemctl start checker.service
sudo systemctl enable checker.service
sudo systemctl daemon-reload
echo "DONE"
############Cron job creation######################
echo "Creating error log parser job"
sudo tee ~/scripts/logparser.sh > /dev/null <<EOT
#!/bin/bash
files=/var/log/*.log
for f in $files
do
less $f | grep -E 'err | warn | fail' >> ~/Errors.log
done
EOT
crontab -l | { cat; echo "00 * * * * $USER ~/scripts/logparser.sh"; } | crontab -
echo "DONE"
echo "End Of Script"