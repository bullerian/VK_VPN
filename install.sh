#! /bin/bash

#Description: VK_VPN service install script
#Dependencies: openvpn, opera
declare -a dependencies=( 'openvpn' 'opera-stable' )

#.ovpn file url
pathToOvpnFile="http://www.vpngate.net/common/openvpn_download.aspx?sid=149\
5615054528&udp=1&host=vpn203976800.opengw.net&port=1933&hid=3388218&/vpngate_vpn\
203976800.opengw.net_udp_1933.ovpn"

vkRoutes='1i#Route only vk.com traffic\nroute-nopull\nroute 87.240.165.82\nroute 95.213.11.180\n'

#Check if dependecy is installed.
#Returns 0 if package is instaled or greater than zero if not.
isDependecyPresent() {
  local nameOfDepend=$1

  dpkg -s $nameOfDepend 2>/dev/null 1>/dev/null;
  echo $?;
}

#Installs package if it is absent. Terminates script on error.
installPackage() {
  local packageName=$1

  if [ $(isDependecyPresent "$packageName") -ne 0 ]; then
    echo -e "\nPackage \"$packageName\" is not instaled. Will try to install it"
    apt install $packageName;

    if [ $? -ne 0 ]; then
      echo -e "\nInstallation error. Package \"$packageName\" is not installed. \
Terminating."
       exit 2;
    fi

    else
      echo -e "\nPackage \"$packageName\" is installed."
  fi
}

#Add Opera deb repo, update packages list
addOperaRepo(){
  echo "Adding Opera repository"
  add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'
  wget -qO- https://deb.opera.com/archive.key | apt-key add -
  apt-get update
}

#Greeting message
echo -e "VK_VPN service installer script\n"

#Check if user is logged as root. Exit if not.
if [ $(id -u) -gt 0 ]; then
  echo "You have to have root privileges to proceed with installation. Terminating."
  exit 1;
fi

#List dependencies
echo "Trying to resolve VK_VPN service dependencies:"
#Call function to add Opera deb repo to repos list
addOperaRepo

#Check and install all packages from the "dependencies" array
for pkg in ${dependencies[*]}; do
  installPackage "$pkg"
done

#Download .ovpn config file from vpngate.net and add vk routes to beginning of
#openVPN config file
wget -qO config.conf $pathToOvpnFile && sed -i "$vkRoutes" config.conf

#copy files to their locations
if [ ! -d "$HOME/.config/systemd/user" ]; then
  mkdir -p "$HOME/.config/systemd/user"
fi

cp config.conf /etc/openvpn && cp vk_vpn.service $HOME/.config/systemd/user && \
sed -i 's/#AUTOSTART="all"\(.*#AUTOSTART="none"\)/AUTOSTART="config"\1/'\
 /etc/default/openvpn

#Service section
systemctl --user enable vk_vpn.service
