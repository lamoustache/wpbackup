#!/bin/bash

# This script backups the higt-toned wordpress website and MySQL database.

# log function
log(){
    message="$@"
    echo $message
    echo $message >>$LOGFILE
}

# backup settings
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="website.$NOW.tar"
BACKUP_DIR=""
WWW_DIR="/var/www/website"
LOGFILE="/var/log/cron/backup.log"

# database credentials
DB_USER="db_user"
DB_PASS="db_password"
DB_NAME="db_name"
DB_FILE="db_file.$NOW.sql"

# transform definition
WWW_TRANSFORM='s,^var/www/website,www,'
DB_TRANSFORM='s,^home/moustache/backups/website,database,'

log "#####################"
log "backup process starts"
log "#####################"
log ""

# archive the wordpress folder and drop it in the backup folder
log " ### archive the wordpress folder and drop it in the backup folder ###"
tar -cvf "$BACKUP_DIR"/"$FILE" --transform "$WWW_TRANSFORM" "$WWW_DIR"
if [ "$?" -ne 0 ]; then
	log "error during creation of the archive"
else 
	log "archive created successfully"
fi

# dump wordpress database and drop it in the backup folder
log " ### dump wordpress database and drop it in backup folder ###"
mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR"/"$DB_FILE"
if [ "$?" -ne 0 ]; then
        log "error during database dump"
else
	log "database dump created successfully"
fi

# add database in the archive
log " ### add database dump to the archive ###"
tar --append --file="$BACKUP_DIR"/"$FILE" --transform "$DB_TRANSFORM" "$BACKUP_DIR"/$DB_FILE"
if [ "$?" -ne 0 ]; then
        log "error during transform"
else
	log "database added to the archive and transform successfull"
fi

# delete the database since it is in the archive
rm "$BACKUP_DIR"/"$DB_FILE"

# gunzip the archive
log " ### compress archive ###"
gzip -9 $BACKUP_DIR/$FILE
if [ "$?" -ne 0 ]; then
	log "error archive not compressed" >> "$LOGFILE"
else
	log "archive successfully compressed" >> "$LOGFILE"
fi

log ""
log "#######################"
log "backup process finished"
log "#######################"
