#!/bin/bash
# Update the backup directory path
backup_dir="/home/dosu.vn/backup"
# Update the code directory path
website_dir="/home/dosu.vn/public_html"
wp_config_file="$website_dir/wp-config.php"
# Update the domain name
domain="dosu.vn"
backup_count=7

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Check if the wp-config.php file exists
if [ ! -e "$wp_config_file" ]; then
    echo "Not found your wp-config.php..."
    sleep 2
    exit
fi

# Get MySQL configuration information from the wp-config.php file
db_name=$(grep 'DB_NAME' "$wp_config_file" | awk -F "'" '{print $4}')
db_user=$(grep 'DB_USER' "$wp_config_file" | awk -F "'" '{print $4}')
db_pass=$(grep 'DB_PASS' "$wp_config_file" | awk -F "'" '{print $4}')

# Create filenames and directories for the backup
timestamp=$(date +%d-%m-%Y)
backup_filename="$domain-$timestamp"
backup_path="$backup_dir/$backup_filename"

# Dump MySQL data
mysqldump -u "$db_user" -p"$db_pass" "$db_name" > "$backup_path.sql"

# Compress data into a .zip file
zip -r "$backup_path.zip" "$website_dir" "$backup_path.sql"

# Remove temporary file
rm "$backup_path.sql"

# Delete old backups if there are more than $backup_count
existing_backups=($(ls -t "$backup_dir" | grep "^$domain-" | grep -E '\.zip$'))
count_existing_backups=${#existing_backups[@]}
if [ $count_existing_backups -gt $backup_count ]; then
    backups_to_delete=${existing_backups[@]:$backup_count}
    for backup in $backups_to_delete; do
        rm "$backup_dir/$backup"
    done
fi
