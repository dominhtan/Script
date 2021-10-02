#!/bin/bash
printf "Insert domain :"
read domain
sudo printf "%s\n" "Insert key: "
read key
echo $key > /etc/tls/pki/private/$domain.key
sudo printf "%s\n" "Insert crt: "
read crt
echo $crt > /etc/tls/pki/certs/$domain.crt

#Insert in Proxy
sudo find /home/proxy/ -type f -name "$domain.conf" | xargs sed -i -e 's/ssl_certificate/#ssl_certificate/g' > $domain.conf
sudo sed -i "4 i ssl_certificate /etc/tls/pki/certs/$domain.crt; ssl_certificate_key /etc/tls/pki/private/$domain.key;" /home/proxy/$domain.conf

#Insert in Nginx
sudo find /etc/nginx/conf.d/ -type f -name "$domain_ssl.conf" | xargs sed -i -e 's/ssl_certificate/#ssl_certificate/g' > $domain.ssl.conf
sudo sed -i "4 i ssl_certificate /etc/tls/pki/certs/$domain.crt; ssl_certificate_key /etc/tls/pki/private/$domain.key;" /etc/nginx/conf.d/$domain_ssl.conf

#Reload Nginx
sudo nginx -t
sudo service nginx reload
