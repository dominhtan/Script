#!/bin/bash
clear
#mkdir -p /home/bkdata2/
ls=`ls -l | awk '/^d/ {print $9}'`
tg=$(date +%d-%m-%Y)
bkup=backup-$tg

function kiemtra {

        select $tenmien in $ls; do
        if (`grep -q '/home/$ls'`); then
                        echo " Danh sách website : $domain "
                break
        else
                        echo " Không thấy website nào "
                sleep 3; exit
                fi
                done
        }
function bkup {
        cd $tenmien
        tar -czf $bkup.tar /home/$tenmien/public_html/*
        mv $bkup.tar /home/bkdata2

        if (`$? -eq 0`); then
                echo " Backup thành công.."
        else
                echo " Backup không thành công"
                        sleep 3;
                exit
        fi

}
function data {
        printf "Nhập username :"
                read a
        printf "Nhập database :"
                read b
        printf "Nhập mật khẩu :"
                read c
        mysqldump -u $a -p$b $c > /home/bkdata2/$bkup.sql << EOF
        if (`$? -eq 0`); then
                echo " Export thành công.."
        else
                echo " Export db không thành công"
                        sleep 3;
                exit
        fi
}
function lchon {
        1)
        read -P "Tên miền cần backup: " chọn
        case $chọn in
        kiemtra
        ;;
        *)
                echo "Lỗi..."; sleep 3
        esac
}
while true
do  
        lchon
        bkup
        data
done
