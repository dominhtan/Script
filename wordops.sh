#!/bin/bash
kpass=`tr -dc A-Za-z0-9 </dev/urandom | head -c 16 ; echo ''`
ipa=`hostname -I | awk '{print $1}'`
os=`cat /etc/os-release | grep "Ubuntu" | head -n 1 | wc -l`
if [ $os -eq 1 ]; then
apt-get update -y
apt-get -option=Dpkg::options::=--force-confmiss --option=Dpkg::options::=--force-confold --assume-yes install build-essential curl gzip python3-pip python3-wheel python3-apt python3-setuptools python3-dev sqlite3 git tar software-properties-common pigz gnupg2 cron ccze rsync apt-transport-https tree haveged ufw unattended-upgrades tzdata ntp php
else
	exit
fi
wo_install () {
        python3 -m pip install -I setuptools==57.5.0
        wget -qO wo wops.cc && sudo bash wo << EOF
        admin
        tenten@runsystem.net
EOF
}
wo_update () {
        python3 -m pip install -U wordops
        cp -rf /usr/local/lib/python3.*/dist-packages/usr/* /usr/
        cp -rn /usr/local/lib/python3.*/dist-packages/etc/* /etc/
        cp -f /usr/local/lib/python3.*/dist-packages/etc/bash_completion.d/wo_auto.rc /etc/bash_completion.d/wo_auto.rc
        wo stack install --quiet --all
	wo stack install --php74
        yes | wo stack upgrade
        yes | wo stack migrate --mariadb
        python3 -m pip install --upgrade pip
}
wo_create () {
        find /etc/wo/ -type f -name "wo.conf" | xargs sed -i -e 's/7.3/7.4/g'
        wo_log_dir=/var/log/wo
        wo_backup_dir=/var/lib/wo-backup
        wo_tmp_dir=/var/lib/wo/tmp
        if [ ! -d "$wo_log_dir" ] || [ ! -d "$wo_backup_dir" ] || [ ! -d "$wo_tmp_dir" ]; then
                mkdir -p "$wo_backup_dir" "$wo_log_dir" "$wo_tmp_dir"
        # create wordops log files
                touch /var/log/wo/{wordops.log,install.log}
                chmod -R 755 "$wo_log_dir" "$wo_backup_dir" "$wo_tmp_dir"
                chown -R root:adm "$wo_log_dir"
        fi
}
wo_ssl () {
# clone the repository
git clone https://github.com/Neilpang/acme.sh.git /opt/acme.sh -q

# create conf directory
mkdir -p /etc/letsencrypt/{config,live,renewal}

# install acme.sh
cd /opt/acme.sh
./acme.sh --install \
            --home /etc/letsencrypt \
            --config-home /etc/letsencrypt/config \
            --cert-home /etc/letsencrypt/renewal

# enable auto-upgrade
/etc/letsencrypt/acme.sh --config-home '/etc/letsencrypt/config' --upgrade --auto-upgrade

# create .well-known directory
mkdir -p /var/www/html/.well-known/acme-challenge

# set www-data as owner
chown -R www-data:www-data /var/www/html /var/www/html/.well-known

# set permissions
chmod 750 /var/www/html /var/www/html/.well-known
}
wo_setup () {
        wo secure --auth admin $kpass
        k_ver=`wo --version | head -n 1 | awk '{print $1}'`
        k_passroot=`cat /etc/mysql/conf.d/my.cnf | tail -n 2 | awk '{print $3}'`
        service=`wo stack status`
        cat <<EOF > /etc/motd
Version $k_ver, Powered by Prime Strategy.
==================================================
WordOPS panel login:
[Weblink]   http://$ipa:22222
[Account]   admin
[Pass   ]   $kpass
File-Manager login:
[Weblink]   https://$ipa:22222/files/
[Account]   admin
[Pass   ]   admin
PHPAdmin login:
[Weblink]   https://$ipa:22222/db/pma/
[Account]   root
[Pass   ]   $k_passroot
Service :
$service
==================================================
EOF
        clear; cat /etc/motd
        echo "SSH login port: 22222"
        echo "Login command: ssh -p 22222 root@$ipa"
}
wo_install
wo_update
wo_create
wo_setup
