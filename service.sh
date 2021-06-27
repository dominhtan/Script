#!/bin/bash
#Kiểm tra tiến trình Process Status trên hệ thống Service.
clear
#Đặt tên
#mysql=MySQL_Service
#crond=Crontab_Service
#ssh=SSH_Connect
#network=Network_Service
#docker=Docker_Service
#php=PHP-FPM

#Gọi biến Service_Stop
php=php-fpm
mysql=mysql.service
crond=crond.service
ssh=sshd
network=network
docker=docker

PS3="Chọn chức năng : "
echo "------------------Do Minh Tan----------------------"
echo "\-------------------------------------------------/"
opt1=("Status" "Auto" "Craft")

                select menu1 in "${opt1[@]}"
                do
                        case $menu1 in
                "Status" )
                                echo " All Process Status : .."
                                systemctl list-units --type service --all
                ;;
                "Auto" )
                echo "List Service..........................."
                        for service in $mysql $php $crond $ssh $network $docker
                        do
                                i=`ps -eaf | grep -i $service |sed '/^$/d' | wc -l`
                                if [ $i -ge 1 ]
                        then
                                echo $service is running
                        else
                                echo $service not running
                                if [ $service -eq 'php' ]
                                then
                                    systemctl start php-fpm.service &&  systemctl start php7.0-fpm.service
                                else
                                        break
                                fi
                                echo Restart $service now...
                                sleep 5
                                systemctl start $service
                                systemctl enable $service
                        fi
                done
                        echo "Checking Web Service...................."

                        if [ systemctl list-units --type service --all | grep 'nginx' | wc -l ]
                                                then
                        echo " Your website is running WebService Nginx "
                                if [ systemctl status nginx | grep 'running' | wc -l -ge 1 ]
                                        then
                                                echo Nginx webservice is running
                                        else
                                                echo Restart Nginx webservice now...
                                                sleep 3
                                                systemctl start nginx
                                                systemctl enable nginx
                                fi
                        elif [ systemctl list-units --type service --all | grep 'lscpd' | wc -l -ge 1 ]
                        then
                        echo "Your website is running WebService LiteSpeed "
                                if [ systemctl status lscpd.service | grep 'running' | wc -l -ge 1 ]
                                        then
                                                echo LiteSpeed webservice is running
                                        else
                                                echo Restart LiteSpeed webservice now...
                                                sleep 3
                                                systemctl start nginx
                                                systemctl enable lscpd.service
                                fi
                        elif [ systemctl list-units --type service --all | grep 'httpd' | wc -l -ge 1 ]
                        then
                        echo "Your website is running WebService Apache "
                                if [ systemctl status httpd.service | grep 'running' | wc -l -ge 1 ]
                                        then
                                                echo Apache webservice is running
                                        else
                                                echo Restart Apache webservice now...
                                                sleep 3
                                                systemctl start httpd.service
                                                systemctl enable httpd.service
                                        fi
                        else
                                echo " Error...404 "
                                break
                        fi
                ;;
esac
done
