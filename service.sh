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
#php=php-fpm
mysql=mysqld.service
crond=crond.service
ssh=sshd
network=network
docker=docker

PS3="Choose 1..4 : "
echo "------------------Do Minh Tan----------------------"
echo "\-------------------------------------------------/"
opt1=("Status" "Auto" "Craft" "Check PHP Version" "Exit")

                select menu1 in "${opt1[@]}"
                do
                        case $menu1 in
                        
                "Status")
                                echo " All Process Status : .."
                                systemctl list-units --type service --all
                ;;

                "Auto")
                echo "******************************************************"
                echo "...................List Service........................"
                echo "*******************************************************"
                for service in $mysql $php $crond $ssh $network $docker
                do
                        if [ `systemctl status $service | grep 'dead' | wc -l` -ge 1 ]
                        then
                                echo $service not running
                                echo Restart $service now...
                                sleep 3
                                systemctl start $service
                                systemctl enable $service
                        elif [ `systemctl status $service | grep "running" | wc -l` -ge 1 ]
                        then
                                echo $service is running

                        elif [ `systemctl status $service | grep "exited" | wc -l` -ge 1 ]
                        then
                                echo $service is running

                        elif [ `ps -eaf | grep -i php | sed '/^$/d' | wc -l` -ge 1 ]
                        then
                                echo PHP is running
                        else 
                                echo " Error..404 : Script continue...."

                        fi
                        done
                        echo "******************************************************"
                        echo "...................Web Service........................"
                        echo "*******************************************************"
                        if [ `systemctl list-units --type service --all | grep 'nginx' | wc -l` -ge 1 ]
                        then
                                echo " Your website is running WebService Nginx "
                                if [ `systemctl status nginx | grep 'running' | wc -l` -ge 1 ]
                                        then
                                                echo Nginx webservice is running
                                        else
                                                echo Restart Nginx webservice now...
                                                sleep 3
                                                systemctl start nginx
                                                systemctl enable nginx
                                fi
                        elif [ `systemctl list-units --type service --all | grep 'lscpd' | wc -l` -ge 1 ]
                        then
                                echo "Your website is running WebService LiteSpeed "
                                if [ `systemctl status lscpd.service | grep 'running' | wc -l` -ge 1 ]
                                        then
                                                echo LiteSpeed webservice is running
                                else
                                                echo Restart LiteSpeed webservice now...
                                                sleep 3
                                                systemctl start nginx
                                                systemctl enable lscpd.service
                                fi
                        elif [ `systemctl list-units --type service --all | grep 'httpd' | wc -l` -ge 1 ]
                        then
                        echo "Your website is running WebService Apache "
                                if [ `systemctl status httpd.service | grep 'running' | wc -l` -ge 1 ]
                                        then
                                                echo Apache webservice is running
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
                ;;
              "Craft")  echo "******************************************************"
                        echo "......................Check............................"
                        echo "*******************************************************"
                        printf "Please enter the service to check... :"
                        read $service_craft

                        is_running=`ps -eaf | grep -i "$service_craft" | sed '/^$/d' | wc -l`
                        if [ "$is_running" -ne 0 ]
                        then
                                 echo $service_craft is running
                        else
                                initd=`ls /etc/init.d/ | awk '{ print $1 }' | grep "$service_craft" | wc -l`
                                if [ "$initd" -eq 1 ]
                                then
                                        startup=`ls /etc/init.d | grep $service_craft`
                                        read answer
                                        if [ $answer -eq "y" -o $answer -eq "Y" ]
                                        then
                                                echo "Starting Service..."
                                                /etc/init.d/${startup} start
                                        else
                                                echo "Error 404...not found"
                                                exit 1
                                        fi
                                else
                                        echo "Service is not installed or not running"
                                        exit 1
                                fi
                        fi                     
                ;;
                "Check PHP Version")

                        printf "Your website need to check PHP Version :"
                        read z

                                if [ cd `/home/$z/public_html/` -eq 0 ]
                                then
                                echo "Checking your website PHP Version..."
                                wget script.jpsharing.net/info.php > /home/$z/public_html/
                                echo `Please run the path to check : $z/info.php`

                                elif [ cd `find /home -type d -name '$z'` ] 
                                then
                                echo "Checking your website PHP Version..."
                                wget script.jpsharing.net/info.php > find /home -type d -name '$z'
                                echo `Please run the path to check : $z/info.php`
                                sleep 2; exit
                        fi
                 ;;       
               "Exit") echo "Exit now..."
                       sleep 3
                       exit
                ;;
         esac
done
