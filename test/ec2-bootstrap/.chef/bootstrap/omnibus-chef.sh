#!/bin/bash -ex

if which curl 2>/dev/null; then
    HTTP_GET_CMD="curl -L"
else
    HTTP_GET_CMD="wget -qO-"
fi

# read/parse user-data
USERDATA=`$HTTP_GET_CMD http://169.254.169.254/latest/user-data`
CHEF_VERSION=`echo $USERDATA | tr -s ',' '\n' | grep "chef_version" | cut -d'=' -f2`
FQDN=`echo $USERDATA | tr -s ',' '\n' | grep "fqdn" | cut -d'=' -f2`

# install Chef
if [ -z "$CHEF_VERSION" ]; then
	$HTTP_GET_CMD https://www.opscode.com/chef/install.sh | sudo bash -s
else
	$HTTP_GET_CMD https://www.opscode.com/chef/install.sh | sudo bash -s -- -v $CHEF_VERSION
fi

# set proper hostname
if [ "$FQDN" ]; then
	HOSTNAME=`echo $FQDN | sed -r 's/\..*//'`
	if [ "`grep "127.0.1.1" /etc/hosts`" ]; then
		sudo sed -r -i "s/^(127[.]0[.]1[.]1[[:space:]]+).*$/\\1$FQDN $HOSTNAME/" /etc/hosts
	else
		sudo sed -r -i "s/^(127[.]0[.]0[.]1[[:space:]]+localhost[[:space:]]*)$/\\1\n127.0.1.1 $FQDN $HOSTNAME/" /etc/hosts
	fi
	sudo sed -i "s/.*$/$HOSTNAME/" /etc/hostname
	sudo hostname -F /etc/hostname
fi

# XXX: ensure that file_cache_path configured in solo.rb exists (Mccloud does not create it)
sudo mkdir -p /var/chef-solo 