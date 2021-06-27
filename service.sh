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
                        elif
                        then
                                echo $service not running
                                if [ $service -eq 'php' ]
                                then
                                    systemctl start php-fpm.service &&  systemctl start php7.0-fpm.service
                                else
                                        break
                                fi
                                echo Start $service now...
                                sleep 5;
                                systemctl start $service
                                systemctl enable $service
                        else
                                echo "Error - Restart script now... $REPLY"
                fi
                done
                                        echo "Checking Web Service...................."

                        #if [ ps -eaf | grep -i $web_service |sed '/^$/d' | wc -l -eq 1 ]
                        #then
                        #echo " Your website running WebService Nginx "

                ;;
esac
done
