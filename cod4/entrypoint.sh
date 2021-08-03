#!/bin/bash

source /etc/apache2/envvars
#tail -F /var/log/apache2/* &

# Changing www-data user id
useridtest=$(id -u www-data)
    if [[ $useridtest -eq ${PUID} ]]
        then
           echo "Id is fine"
    else
           usermod -u ${PUID} www-data
           echo "change id"
    fi

# Changing www-data group id
groupidtest=$(id -g www-data)
    if [[ $groupidtest -eq ${PGID} ]]
        then
           echo "Id is fine"
    else
           usermod -g ${PGID} www-data
           echo "change id"
    fi

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
