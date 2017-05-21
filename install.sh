#! /bin/sh

#Description: VK_VPN service install script
#Dependencies: openvpn, opera



#User have to be logged as root
# if [ $(id -u) -gt 0 ]; then
#   echo "You have to be logged as root to proceed with installation. Terminating."
# #  exit 1;
# fi

isDependecyPresent() {
  local nameOfDepend=$1

  dpkg -s $nameOfDepend 2>/dev/null 1>/dev/null;
  echo $?;
}

#Check if openvpn is allready installed




var=$(isDependecyPresent 'vim');

echo $var;
