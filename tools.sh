#!/bin/bash
PS3='Chọn chức năng cần hỗ trợ: '
options=("Dung lượng " "Inode " "Ổ đĩa " "Traffic " "Thoát ")
select menu in "${options[@]}"
do

    case $menu in
        "Dung lượng ")
            echo "Những tệp lớn nhất của quý khách tại $(pwd)"
        du -a | awk '{print $1,$2}' | sort -rn | uniq -c | head -10
            ;;
        "Inode ")
            echo "Số lượng inode ở $(pwd)"
        find . -printf "%h\n" | sort | uniq -c | sort -rn
            ;;
        "Ổ đĩa ")
            echo "Check ổ đĩa ở $(pwd)"
        df -ah
            ;;
        "Traffic ")
                echo "Chọn truy cập http hay https"
                opt1=("http " "https " "Trở về ")
                select traffic1 in "${opt1[@]}"
                do
                case $traffic1 in
                "http ")
        echo " Request của khách truy cập dưới dạng http "
        watch "netstat -an | grep ':80' | awk '{print \$5}' | sed s/'::ffff:'// | cut -d\":\" -f1 | sort | uniq -c"
                ;;
                "https ")
        echo " Request của khách truy cập dưới dạng https "
        watch "netstat -an | grep ':443'| awk '{print \$5}' | sed s/'::ffff:'// | cut -d\":\" -f1 | sort | uniq -c"
                ;;
                "Trở về ")
                menu
        esac
        done
        ;;
        "Thoát ")
                echo " Xác nhận thoát "
                break
        ;;
        *) echo "Vui lòng chọn lại từ 1 đến 4 $REPLY"
        ;;
    esac
done
