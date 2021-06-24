#Backup website trên CyberPanel
#!/bin/bash
#mkdir -p /home/fbkup
dest="/home/fbkup"
domain="/home/jpsharing.net/public_html/*"
ngay="$(date +%d-%m-%Y)"
zbkup="backup-$ngay.tar.gz"
function bkup {
        tar -czf $zbkup $domain
        mv $zbkup $dest
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
