#!/bin/bash
#
# Script to install WebBrowser on Pi-Star
#         Modify by Rodrigo Lenard (PU7KRL)
#

# Remount root as writable partition
sudo mount -o remount,rw /
sudo mount -o remount,rw /boot

# Update resources
sudo apt-get update

# Patch Library
if [[ $(cut -c 1 /etc/debian_version) -eq 9 ]]; then
	sudo apt-get install -y --reinstall libraspberrypi0 libraspberrypi-dev libraspberrypi-bin
fi

# Install GUI Interface and browser
sudo apt-get install -y --no-install-recommends xserver-xorg
sudo apt-get install -y --no-install-recommends xinit
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y raspberrypi-ui-mods
sudo apt-get install -y lightdm

# Install unclutter to remove the pointer
sudo apt-get install -y unclutter chromium-browser

# Modify autostart parameters
mkdir /home/pi-star/.config
mkdir /home/pi-star/.config/lxsession
mkdir /home/pi-star/.config/lxsession/LXDE-pi
touch /home/pi-star/.config/lxsession/LXDE-pi/autostart
sed -i 's/@xscreensaver -no-splash/#@xscreensaver -no-splash/g' /home/pi-star/.config/lxsession/LXDE-pi/autostart
echo "@xset s off" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart
echo "@xset s noblank" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart
echo "@xset -dpms" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart

# Add browser autostart
echo "@chromium-browser --noerrdialogs --kiosk --incognito http://localhost/dashboard" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart

# Add autologin user and pass
sudo sed -i 's/#autologin-user=/autologin-user=pi-star/g' /etc/lightdm/lightdm.conf
sudo sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

# Permission writable the .config dir
sudo chown -R pi-star:pi-star /home/pi-star/.config

# Install dashboard dir web
sudo git clone https://github.com/rodrigolenard/dashboard.git /var/www/dashboard/dashboard
cd /var/www/dashboard/dashboard
sudo unzip dashboard.zip
sudo rm -rf dashboard.zip
sudo chmod 777 /var/www/dashboard/dashboard

# Force the disk to be RW on boot
sudo sed -i 's/mount -o remount,ro \///g' /etc/rc.local
sudo reboot
