#Backup website trên CyberPanel
#!/bin/bash
#mkdir -p /home/fbkup
domain=`ls -l /home/jpsharing.net/public_html`
ngay=$(date +%d-%m-%Y)
file_name="backup-$ngay"
function bkup {
        tar -cvf $file_name.tar $domain
        mv $file_name.tar /home/fbkup
        if (`$? -eq 0`); then
                echo " Thành công, đang chuyển code > /home/fbkup ..."
        else
                echo " Backup không thành công"
                        sleep 3;
                exit
        fi
}
function db {
        mysqldump -u 5nC2zo7rLBG9z4 -p5nC2zo7rLBG9z4 CvBoIvTfPQVvlr > /home/fbkup/$file_name.sql

        if (`$? -eq 0`); then
                echo " Thành công, đang chuyển db > /home/fbkup ..."
        else
                echo " Backup không thành công"
                        sleep 3;
                exit
        fi

}
while true
do
        bkup
        db
done
