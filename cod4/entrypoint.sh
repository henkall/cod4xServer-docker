#!/bin/bash

source /etc/apache2/envvars
#tail -F /var/log/apache2/* &

foldergamefiles=$(stat --format '%a' /root/gamefiles)
    if [[ $foldergamefiles -eq 2777 ]] || [[ $folderzone -eq 777 ]]
        then
           echo "Permissions on 'gamefiles' directory fine"
    else
           echo "ERROR: Permissions on 'gamefiles' directory has to be 777 or 2777"
           chmod -R 2777 /root/gamefiles
           echo "fix applied to gamefiles ----"
    fi

exec apache2 -D FOREGROUND
