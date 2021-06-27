#Backup website trên CyberPanel
#!/bin/bash
#mkdir -p /home/fbkup
dest="/home/fbkup"
domain="/home/###/public_html/*"
ngay="$(date +%d-%m-%Y)"
zbkup="backup-$ngay.tar.gz"
function bkup {
        tar -czf $zbkup $domain
        
        if (`$? -eq 0`); then
                echo " Thành công, đang chuyển code > /home/fbkup ..."
                mv $zbkup $dest
        else
                echo " Backup không thành công"
                        sleep 3;
                exit
        fi
}
function db {
        mysqldump -u -p  > /home/fbkup/$zbkup.sql

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
