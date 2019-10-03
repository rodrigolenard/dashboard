#!/bin/bash
#
# Script to install WebBrowser on Pi-Star
#   Modify by Rodrigo Lenard (PU7KRL)
#

# Usar todo o cartão
sudo pistar-expand

# Remonta em modo gravação
sudo mount -o remount,rw /
sudo mount -o remount,rw /boot

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Patch
if [[ $(cut -c 1 /etc/debian_version) -eq 9 ]]; then
sudo apt-get install -y --reinstall libraspberrypi0 libraspberrypi-dev libraspberrypi-bin
fi

# Instala interface and browser
sudo apt-get install -y --no-install-recommends xserver-xorg
sudo apt-get install -y --no-install-recommends xinit
sudo apt-get install -y raspberrypi-ui-mods
sudo apt-get install -y lightdm
sudo apt-get install -y unclutter chromium-browser

# Download e instalação do dashboard
sudo git clone https://github.com/rodrigolenard/dashboard.git /var/www/dashboard/dashboard
cd /var/www/dashboard/dashboard
sudo unzip dashboard.zip
sudo rm -rf dashboard.zip pi-star-gui.sh
sudo chmod 777 /var/www/dashboard/dashboard

# Configura autostart
mkdir /home/pi-star/.config
mkdir /home/pi-star/.config/lxsession
mkdir /home/pi-star/.config/lxsession/LXDE-pi
touch /home/pi-star/.config/lxsession/LXDE-pi/autostart
sed -i 's/@xscreensaver -no-splash/#@xscreensaver -no-splash/g' /home/pi-star/.config/lxsession/LXDE-pi/autostart
echo "@xset s off" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart
echo "@xset s noblank" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart
echo "@xset -dpms" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart

# Adiciona browser autostart
echo "@chromium-browser --noerrdialogs --kiosk --incognito http://localhost/dashboard" >> /home/pi-star/.config/lxsession/LXDE-pi/autostart

# Add autologin
sudo sed -i 's/#autologin-user=/autologin-user=pi-star/g' /etc/lightdm/lightdm.conf
sudo sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

# Permissão de escrita no arquivi .config
sudo chown -R pi-star:pi-star /home/pi-star/.config

# Force the disk to be RW on boot
sudo sed -i 's/mount -o remount,ro \///g' /etc/rc.local
sudo reboot
