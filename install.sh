#! /bin/bash -e

echo '
 _    _ _                     _             
| | _(_) |__   ___ _ __ _ __ (_)_ __   __ _ 
| |/ / | |_ \ / _ \ |__| |_ \| | |_ \ / _` |
|   <| | |_) |  __/ |  | |_) | | |_) | (_| |
|_|\_\_|_.__/ \___|_|  | .__/|_| .__/ \__,_|
                       |_|     |_|          
'

echo -e "\nDISCLAIMER:\nI f***ing know what this script does and I can read bash. \n\n Please write the the magic word. And press enter."

read  a1

# Stops n00bsfrom doing weird stuff
        echo
            if [ "$a1" != "mamba" ]
                then
                    echo "HAHA, u cant read bash, u poor guy"
		    exit 1
            fi


apt-get update
apt-get -y install aptitude git-core


###
# AutoFS part
##

# Clone the autofs config from brodul git repo
git clone git://github.com/brodul/kiberpipa-autofs-config.git

# Install the deps for autofs
yes | aptitude -y --full-resolver install autofs portmap nfs-common

# Install the confs
cp kiberpipa-autofs-config/auto.master /etc/
cp kiberpipa-autofs-config/auto.nfs /etc/

# Restart autofs
service autofs restart

########


###
# LDAP part
###

# Clone the LDAP client config from brodul repo
git clone git://github.com/brodul/kiberpipa-ldap-config.git

# Install the deps for LDAP client
DEBIAN_FRONTEND=noninteractive aptitude -y --full-resolver install libpam-ldap libnss-ldap nss-updatedb libnss-db

# Install the confs
cp kiberpipa-ldap-config/pam_ldap.conf /etc/pam_ldap.conf
cp kiberpipa-ldap-config/ldap.conf /etc/
cp kiberpipa-ldap-config/libnss-ldap.conf /etc/
cp kiberpipa-ldap-config/nsswitch.conf /etc/

# Back up the default config
mv /etc/ldap/ldap.conf /etc/ldap/ldap.confBACKUP

# Link the configs for safety
ln -s /etc/ldap.conf /etc/ldap/ldap.conf
ln -s /etc/libnss-ldap.conf /etc/ldap/

#######


###
# PAM part !!!!!  You MUST be crazy to automate that  !!!!!!
###

# Clone the PAM config from brodul repo
git clone git://github.com/brodul/kiberpipa-pam-config.git

# Back up the default config
mv /etc/pam.d/common-account /etc/pam.d/common-accountBACKUP
mv /etc/pam.d/common-auth /etc/pam.d/common-authBACKUP
mv /etc/pam.d/common-password /etc/pam.d/common-passwordBACKUP

# Install the confs
cp kiberpipa-pam-config/common-account /etc/pam.d/common-account
cp kiberpipa-pam-config/common-auth /etc/pam.d/common-auth
cp kiberpipa-pam-config/common-password /etc/pam.d/common-password

#######


###
# Post install stuff
###

mkdir -p /opt/home/
mkdir -p /opt/home/pipa
usermod  -d /opt/home/pipa pipa
