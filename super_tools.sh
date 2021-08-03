#!/bin/bash

#Kiểm tra tiến trình Trạng thái
echo "================================================================"
# Check số lượng inode :
dui=`df -hi | sed -n '2p' | awk '{print $5}' | grep -v U`
echo "Inode usage on `hostname` is exceeded : $dui"
dus=`df -h | sed -n '6p' | awk '{print $5}' | grep -v U`
echo "Disk usage on `hostname` is exceeded : $dus"
echo "________________________________________________________________"
echo "-------------------------TimeZone-------------------------------"
#Kiểm tra thời gian hiện tại
function timez {
time=`curl -s http://ip-api.com/line?fields=timezone`
echo "Status : $time "
date "+%A %B %d %T %y ||"
}
function phpz {
        php -v | grep 'PHP ' | awk '{print $1, $2}'| head -n 1
}
echo `timez && phpz`
echo "----------------------------------------------------------------"
echo "                       Do Minh Tan                              "
echo "----------------------------------------------------------------"
echo "________________________________________________________________"

function webz {
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
        }
echo                             `webz`
echo "________________________________________________________________"
echo "--------------------------Service-------------------------------"

# Kiểm tra Service
function mysqlz {

                        if [ ` systemctl status mysqld.service | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "Service MySql = ON ||"
                        else
                                echo "Please install MySql or start MySql now."
                                echo "Service MySql = OFF ||"
                        fi
                }
function dockerz {
                        if [ ` systemctl status docker.service | grep -q 'running' | wc -l` -ge 1 ]
                        then
                                echo "Docker = ON ||"
                        else
                                echo "Please install Docker or start service now."
                                echo "Docker = OFF ||"
                        fi
                }
function sshz  {
                        if [ `systemctl status sshd | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "SSH = Opening ||"
                        else
                                echo "Please install SSH or open SSH now."
                                echo "SSH = Close ||"
                        fi
                }
function cronz {
                        if [ `systemctl status crond.service | grep 'running' | wc -l` -ge 1 ]
                        then
                                echo "Service Cron = ON ||"
                        else
                                echo "Please install Cron or open Cron now."
                                echo "Service Cron = Close ||"
                        fi
                }


        echo `dockerz`
        echo `mysqlz && sshz && cronz`


echo "________________________________________________________________"
PS3="Choose 1..n : "
opt1=("Update" "Upgrade" "Backup WordPress" "Check PHP Version" "Watch IP" "")
        select menu1 in "${opt1[@]}"
                do
                        case $menu1 in
                                "Update" )
                                        if [`cat /etc/os-release | grep -q 'CentOS'`]
                                        then
                                                yum update -y
                                                echo " Update CentOS complete !!"
                                                sleep 2
                                        elif [`cat /etc/os-release | grep -q 'Ubuntu'`]
                                        then
                                                apt-get update -y
                                                echo " Update Ubuntu complete !!"
                                                sleep2
                                        else
                                                echo "Error...404"
                                                break
                                        fi
                                        ;;
                                "Upgrade" )
                                        if [`cat /etc/os-release | grep -q 'CentOS'`]
                                        then
                                                yum upgrade -y
                                                echo " Update CentOS complete !!"
                                                sleep 2
                                        elif [`cat /etc/os-release | grep -q 'Ubuntu'`]
                                        then
                                                apt-get upgrade -y
                                                echo " Update Ubuntu complete !!"
                                                sleep2
                                        else
                                                echo "Error...404"
                                                break
                                        fi
                                        ;;
                                "Backup WordPress" )
                                        function check {

                                                cd /home/
                                                ls=`ls -l | grep ^d | awk '{print $9}' | find * -type d -name 'public_html' | cut -d "/" -f 1`
                                                PS3="Chose domain backup: "
                                                        select domain in $ls; do
                                                                 if [ -f $domain/public_html/wp-config.php ]
                                                                then
                                                                        break
                                                                else
                                                                        echo "Not found your Website running WordPress..."
                                                                        sleep 2
                                                                        exit
                                                                fi
                                                         done
                                                        }
                                        function bkdb {

                                                cd /home/$domain/public_html/
                                                if [ `ls -l | grep 'wp-config.php' | wc -l` -ge 1 ]
                                                then
                                                        db_name=`grep 'DB_NAME' wp-config.php | awk -F "'" '{print $4}'`
                                                        db_user=`grep 'DB_USER' wp-config.php | awk -F "'" '{print $4}'`
                                                        db_pass=`grep 'DB_PASS' wp-config.php | awk -F "'" '{print $4}'`
                                                else
                                                        echo "Not found your wp-config.php..."
                                                                sleep 2
                                                exit
                                                fi
                                                        mysqldump -u $db_user -p$db_pass $db_name > $domain-$tg.sql
                                                        mv $domain-$tg.sql /home/bkup

                                                if [ $? -eq 0 ]; then
                                                        echo "Backup database successful"
                                                else
                                                        echo "Backup database fail"
                                                        sleep 2; exit
                                                fi
                                                        }

                                        function bkcode {

                                                cd /home/$domain/public_html/
                                                tar -czf $domain-$tg.tar.gz *
                                                mv $domain-$tg.tar.gz /home/bkup
                                                if [ $? -eq 0 ]; then
                                                        echo "Backup code $domain successful"
                                                else
                                                        echo "Backup code $domain fail"
                                                fi
                                                        }
                                        function exitz {
                                                        $menu1
                                                        }

                                                while true
                                                do
                                                        check
                                                        bkdb
                                                        bkcode
                                                        exitz
                                               done

                                        ;;
                                        "Check PHP Version" )
                                        function check {

                                        cd /home/
                                                ls=`ls -l | grep ^d | awk '{print $9}' | find * -type d -name 'public_html' | cut -d "/" -f 1`
                                                PS3="Chose domain backup: "
                                                        select domain in $ls; do
                                                                 if [ -f $domain/public_html/ ]
                                                                then
                                                                        break
                                                                else
                                                                        echo "Not found your Website ..."
                                                                        sleep 2
                                                                        exit
                                                                fi
                                                         done
                                        }
                                        function infoz {
                                        wget -q script.jpsharing.net/info.php
                                        mv info.php `find /home -type d -not -path '*/\.*' | grep $domain/public_html | head -n 1`
                                        echo "*******************************************************"
                                        echo "...................Checking PHP Version................"
                                        echo "*******************************************************"
                                        echo Please run the path to check PHP Version : $domain/info.php
                                                }
                                        check
                                        infoz
                                        ;;
                                esac
                        done
