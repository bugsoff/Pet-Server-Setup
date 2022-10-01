#!/bin/bash


read -r -p "Input login user name for SSH (default: root@${HOSTNAME}): " LOGIN_USER_NAME
LOGIN_USER_NAME=${LOGIN_USER_NAME:-"root@${HOSTNAME}"}

read -r -p "Input path for SSH-keys (default: /root/.ssh/${LOGIN_USER_NAME}): " SSH_KEY_PATH
SSH_KEY_PATH=${SSH_KEY_PATH:-"/root/.ssh/${LOGIN_USER_NAME}"}

ssh-keygen -t rsa -b 4096 -C ${LOGIN_USER_NAME} -f ${SSH_KEY_PATH}
cat "${SSH_KEY_PATH}.pub" >> /root/.ssh/authorized_keys







echo -e "\nDONE!
Use ${SSH_KEY_PATH} to SSH login from another machine, like this:
ssh -i /home/keys/${LOGIN_USER_NAME} ${LOGIN_USER_NAME}
"
