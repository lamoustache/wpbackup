Backup Wordpress
=================

Simple bash script used to backup a wordpress website.

Modify the variables accordingly to the setup.

    FILE = name of the archive
    BACKUP_DIR = name of the backup directory
    WWW_DIR = website location
    LOGFILE = logfile location 

    DB_USER = database username
    DB_PASS = database password
    DB_NAME = database name
    DB_FILE = database sql filename

    WWW_TRANSFORM = website transform
    DB_TRANSFORM = database transform

The script should be called from a cron job

    cat /etc/cron.daily/backup

    #!/bin/bash
    /home/moustache/scripts/wpbackup.sh

    
