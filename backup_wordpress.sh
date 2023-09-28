#!/bin/bash
//Sửa đường dẫn chứa backup
backup_dir="/home/dosu.vn/backup"
//Sửa đường dẫn chứa code
website_dir="/home/dosu.vn/public_html"
wp_config_file="$website_dir/wp-config.php"
//Sửa đường tên miền
domain="dosu.vn"
backup_count=7

# Tạo thư mục backup nếu nó không tồn tại
mkdir -p "$backup_dir"

# Kiểm tra xem có tệp wp-config.php không
if [ ! -e "$wp_config_file" ]; then
    echo "Not found your wp-config.php..."
    sleep 2
    exit
fi

# Lấy thông tin cấu hình MySQL từ tệp wp-config.php
db_name=$(grep 'DB_NAME' "$wp_config_file" | awk -F "'" '{print $4}')
db_user=$(grep 'DB_USER' "$wp_config_file" | awk -F "'" '{print $4}')
db_pass=$(grep 'DB_PASS' "$wp_config_file" | awk -F "'" '{print $4}')

# Tạo tên tệp và thư mục cho backup
timestamp=$(date +%d-%m-%Y)
backup_filename="$domain-$timestamp"
backup_path="$backup_dir/$backup_filename"

# Dump MySQL
mysqldump -u "$db_user" -p"$db_pass" "$db_name" > "$backup_path.sql"

# Nén dữ liệu vào file .zip
zip -r "$backup_path.zip" "$website_dir" "$backup_path.sql"

# Xóa file tạm thời
rm "$backup_path.sql"

# Xóa các backup cũ nếu có nhiều hơn $backup_count
existing_backups=($(ls -t "$backup_dir" | grep '^domain-' | grep -E '\.zip$'))
count_existing_backups=${#existing_backups[@]}
if [ $count_existing_backups -gt $backup_count ]; then
    backups_to_delete=${existing_backups[@]:$backup_count}
    for backup in $backups_to_delete; do
        rm "$backup_dir/$backup"
    done
fi
