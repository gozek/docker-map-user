#!/bin/bash

if [ -z "${USER}" ]; then
	echo "No user is set. Exiting...";
	exit 100
fi

if [ -z "${USER_ID}" -a -z "${USER_GID}" ]; then
	echo "No UID or GID is set. Exiting..." ;
	exit 0
fi

LINE=$(grep -F "${USER}" /etc/passwd)

# Replace all ':' with a space and create array
array=( ${LINE//:/ } )

# Home is 5th element
USER_HOME=${array[4]}

# Insert the desired user and group as account information
sed -i -e "s/^${USER}:\([^:]*\):[0-9]*:[0-9]*/${USER}:\1:${USER_ID}:${USER_GID}/"  /etc/passwd
sed -i -e "s/^${USER}:\([^:]*\):[0-9]*/${USER}:\1:${USER_GID}/"  /etc/group

# Change permissions
chown -R ${USER_ID}:${USER_GID} ${USER_HOME}

# Switch to the desired user
exec su - "${USER}"
