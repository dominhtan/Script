#!/bin/bash

#Kiểm tra tiến trình Trạng thái
echo "=======================DO MINH TAN=============================="
# Check số lượng inode :
dui=`df -hi | sed -n '2p' | awk '{print $5}' | grep -v U`
echo "Inode usage on `hostname` is exceeded : $dui"
echo "________________________________________________________________"
echo "----------------------TimeZone----------------------------------"
#Kiểm tra thời gian hiện tại
time=`curl -s http://ip-api.com/line?fields=timezone`
echo "Status : $time "
date "+%A %B %d %T %y"
echo "________________________________________________________________"
echo "----------------------WebService--------------------------------"


                        if [ `systemctl list-units --type service --all | grep 'nginx' | wc -l` -ge 1 ]
                        then

                                if [ `systemctl status nginx | grep 'running' | wc -l` -ge 1 ]
                                        then
                                                echo Your website is running WebService Nginx
                                        else
                                                echo Restart Nginx webservice now...
                                                sleep 3
                                                systemctl start nginx
                                                systemctl enable nginx
                                fi
                        elif [ `systemctl list-units --type service --all | grep 'lscpd' | wc -l` -ge 1 ]
                        then

                                if [ `systemctl status lscpd.service | grep 'running' | wc -l` -ge 1 ]
                                        then
                                                echo Your website is running WebService LiteSpeed
                                else
                                                echo Restart LiteSpeed webservice now...
                                                sleep 3
                                                systemctl start nginx
                                                systemctl enable lscpd.service
                                fi
                        elif [ `systemctl list-units --type service --all | grep 'httpd' | wc -l` -ge 1 ]
                        then
                                if [ `systemctl status httpd.service | grep 'running' | wc -l` -ge 1 ]
                                        then
                                                echo our website is running WebService Apache
                                        else
                                                echo Restart Apache webservice now...
                                                sleep 3
                                                systemctl start httpd.service
                                                systemctl enable httpd.service
                                        fi
                        else
                                echo " Error 404...Not found WebService "
                                break
                        fi
echo "________________________________________________________________"
echo "----------------------Service-----------------------------------"

# Kiểm tra Service

                        if [ `systemctl status mysqld.service | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "Service MySql = ON"
                        else
                                echo "Service MySql = OFF"
                        fi
                        if [ `systemctl status docker.service | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "Docker = ON"
                        else
                                echo "Please install Docker or start service now."
                                echo "Docker = OFF"
                        fi
                        if [ `systemctl status sshd | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "SSH = Opening"
                        else
                                echo "SSH = Close"
                        fi
                        if [ `systemctl status crond.service | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "Service Cron = ON"
                        else
                                echo "Service Cron = Close"
                        fi

echo "________________________________________________________________"
