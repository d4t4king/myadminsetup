#!/usr/bin/bash

# Author: Charlie Heselton
# Contact: charles.heselton@gmail.com
# Started: 07/21/2021

is_installed_s() {
	PKG=$1
	FOUND=$(dpkg --get-selections | grep "install" | cut -f1 | cut -d: -f1 | grep "^${PKG}$")
	if [[ "${FOUND}x" == "x" ]]; then 	# not found
		echo "FALSE"
	else
		echo "TRUE"
	fi
}

is_running_s() {
	PKG=$1
	FOUND=$(ps -ef | grep -v grep | grep "^${PKG}$")
}

# check is root
if [[ $(id -u) == 0 ]]; then
	APTCMD='apt'
else
	APTCMD='sudo apt'
fi

# check for .bash_aliases, create if missing
if [[ -e ~/.bash_aliases ]]; then
	echo ".bash_aliases exists in this user's home directory."
else
	echo ".bash_aliases doesn't exist.  Creating...."
	echo "alias ls='ls --color=auto'" >> ~/.bash_aliases
	echo "alias ll='ls -lA'" >> ~/.bash_aliases
	echo "alias rm='rm -i'" >> ~/.bash_aliases
	echo "alias cp='cp -i'" >> ~/.bash_aliases
fi

# check if vim-tiny is installed and NOT vim
# if so, remove vim-tiny and install vim
STATUS=$(is_installed_s vim-tiny)
echo "$STATUS"
if [[ $STATUS == "TRUE" ]]; then
	#echo "STATUS is TRUE"
	echo "Swapping vim-tiny for vim."
	${APTCMD} remove vim-tiny -y && ${APTCMD} install vim -y
else
	#echo "STATUS is FALSE"
	echo "vim-tiny is not installed."
fi


# create the ssh keys if they don't exist
if [ ! -e ~/.ssh -a ! -d ~/.ssh ]; then
	ssh-keygen -t rsa -b 4096
else
	echo ".ssh directory exists."
fi


