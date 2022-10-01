#!/bin/bash

echo -e "\n\n--------[ https://github.com/bugsoff/Pet-Server-Setup ]--------\n"

function err {
	echo -e "\n$1"
	exit 1
}

[[ $(id -u) -eq 0 ]] || err "Please run this script as root (sudo $0)"


# SSH

while true; do
	read -r -p "Setup SSH access? [y/n]: " SETUP_SSH
	[[ ${SETUP_SSH,,} =~ ^y(es)?$ ]] && SETUP_SSH=y
	[[ ${SETUP_SSH,,} =~ ^no?$ ]] && SETUP_SSH=n
	[[ ${SETUP_SSH} =~ ^(y|n)$ ]] && break
done

if [[ "$SETUP_SSH" == "y" ]]; then
	echo -e "\n\n--------[ SSH setup ]--------\n"

	read -r -p "Input login user name for SSH (default: root@${HOSTNAME}): " LOGIN_USER_NAME
	LOGIN_USER_NAME=${LOGIN_USER_NAME:-"root@${HOSTNAME}"}

	read -r -p "Input path for SSH-keys (default: /root/.ssh/${LOGIN_USER_NAME}): " SSH_KEY_PATH
	SSH_KEY_PATH=${SSH_KEY_PATH:-"/root/.ssh/${LOGIN_USER_NAME}"}

	ssh-keygen -t rsa -b 4096 -C ${LOGIN_USER_NAME} -f ${SSH_KEY_PATH}
	cat "${SSH_KEY_PATH}.pub" >> /root/.ssh/authorized_keys
else
	echo -e "\n\n--------[ NO SSH setup ]--------\n"
fi




# echo -e "\n\n--------[ VPN setup ]--------\n"
# echo -e "You should to input a VPN user (may to change later)
# and a new SSH user to login via SSH instead of root account (you can delete it later)"
# wget https://raw.githubusercontent.com/jawj/IKEv2-setup/master/setup.sh -O ./ikev2-vpn-setup.sh
# chmod u+x ikev2-vpn-setup.sh
# ./ikev2-vpn-setup.sh



echo -e "\nDONE!"

[[ "$SETUP_SSH" == "y" ]] && 
echo -e "Use ${SSH_KEY_PATH} to SSH login from another machine, like this:
ssh -i /home/keys/${LOGIN_USER_NAME} ${LOGIN_USER_NAME}
"

# if VPN installer you should make PermitRootLogin = yes
