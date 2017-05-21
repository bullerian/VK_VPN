#! /bin/bash

#Description: VK_VPN service install script
#Dependencies: openvpn, opera
declare -a dependencies=( 'openvpn' 'opera' )

#User have to be logged as root
if [ $(id -u) -gt 0 ]; then
  echo "You have to be logged as root to proceed with installation. Terminating."
  exit 1;
fi

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

#Greeting message
echo -e "VK_VPN service installer script\n"

#List dependencies
echo "Trying to resolve VK_VPN service dependencies:"
for pkg in ${dependencies[*]}; do
  installPackage "$pkg"
done
