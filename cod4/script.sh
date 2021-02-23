#!/bin/bash
echo "Server Starting ----------------------------------------------------------------------------------"
if [ -d "main" ]
then
    echo " Directory main exists."
    foldermain=$(stat --format '%a' /home/cod4/gamefiles/main)
    if [ $foldermain -eq 2777 -o $foldermain -eq 777 ]
	then
	   echo "Permissions on 'main' directory fine"
    else
	   echo "ERROR: Permissions on 'main' directory has to be 777 or 2777"
	   chmod -R 777 /home/cod4/gamefiles/main
	   echo "fix applied to main ---------------------------------------------------------------------------"
    fi
else
    echo "ERROR: Directory main is missing."
fi
if [ -d "zone" ]
then
    echo " Directory zone exists."
    folderzone=$(stat --format '%a' /home/cod4/gamefiles/zone)
    if [ $folderzone -eq 2777 -o $folderzone -eq 777 ]
	then
	   echo "Permissions on 'zone' directory fine"
    else
	   echo "ERROR: Permissions on 'zone' directory has to be 777 or 2777"
	   chmod -R 777 /home/cod4/gamefiles/zone
	   echo "fix applied to zone ---------------------------------------------------------------------------"
    fi
else
    echo "ERROR: Directory zone is missing"
fi
if [ -d "Mods" ]
then
    echo " Directory Mods exists."
else
    echo "ERROR: Directory Mods is missing"
    mkdir Mods
    echo "Mods directory has been created"
fi
if [ -d "usermaps" ]
then
    echo " Directory usermaps exists."
    ls -1 /home/cod4/gamefiles/usermaps/ > /home/cod4/.callofduty4/usercustommaps.list
else
    echo "ERROR: Directory usermaps is missing"
    mkdir usermaps
    echo "usermaps directory has been created"
fi
if [ -d "/home/cod4/gamefiles" ]
then
	echo " Directory gamefiles exists"
	chmod -R 777 /home/cod4/gamefiles
	chown -R $PUID:$PGID /home/cod4/gamefiles
	echo "Permissions fine"
	if [ ! -f cod4x18_dedrun ]
	then
		echo "cod4x18_dedrun not found... trying to download it."
		if [ $GETGAMEFILES -eq 1 ]
		then
			curl http://linuxgsm.download/CallOfDuty4/cod4x18_1790_lnxded.tar.xz -o cod4x18.tar.xz && tar -xf cod4x18.tar.xz && rm cod4x18.tar.xz
			curl https://raw.githubusercontent.com/henkall/docker-cod4/master/cod4xfilesnew.zip -o cod4xfiles.zip && unzip -o cod4xfiles.zip && rm cod4xfiles.zip
			chmod -R 777 runtime
			chown -R $PUID:$PGID runtime
		else
			curl https://raw.githubusercontent.com/henkall/docker-cod4/master/cod4xfilesnew.zip -o cod4xfiles.zip && unzip -o cod4xfiles.zip && rm cod4xfiles.zip
			chmod -R 777 runtime
			chown -R $PUID:$PGID runtime
		fi
		echo "Download Done"
		chmod +x cod4x18_dedrun
		echo ready
		chmod -R 777 /home/cod4/gamefiles
		chown -R $PUID:$PGID /home/cod4/gamefiles
	else
		chmod +x cod4x18_dedrun
		echo "cod4x18_dedrun found" 
	fi
fi

echo "Setting server type"
if [ -z "${SERVERTYPE}" ] 
then
  echo "The SERVERTYPE variable is empty."
  SERVERTYPE="1"
fi
echo "Setting port"
if [ -z "${PORT}" ] 
then
  echo "The PORT variable is empty."
  PORT="28960"
fi
echo "Setting EXTRA arg"
if [ -z "${EXTRA}" ] 
then
  echo "The EXTRA variable is empty."
  EXTRA="+set sv_authorizemode -1"
fi
echo "Setting exec file"
if [ -z "${EXECFILE}" ] 
then
  echo "The EXECFILE variable is empty."
  EXECFILE="server.cfg"
fi
echo "Setting MAP"
if [ -z "${MAP}" ] 
then
  echo "The MAP variable is empty."
  MAP="+map_rotate"
fi
echo "Checking if READY"
echo "server is good"
if [ ! -z "${READY}" ] 
then
	echo "Config is Ready"
	if [ ! -f autoupdate.lock ]
	then
	echo "Server is ready for updates if any"
	else
	echo "autoupdate.lock fund. Please remove it if this fails"
	rm -r autoupdate.lock
	fi
	if [[ ! -z "${MODNAME}" ]]; then
		echo "Mod enabled (using $MODNAME mod)"
		if [ $MODNAME = "modernpaintball" ]
		then
			if [ -d "Mods/modernpaintball" ]
			then
			    echo "Directory modernpaintball exists."
			else
			    echo "ERROR: Directory modernpaintball is missing."
			    # curl https://raw.githubusercontent.com/henkall/docker-cod4/master/modernpaintball.zip -o modernpaintball.zip && unzip -o modernpaintball.zip && rm modernpaintball.zip
			    echo "Mod downloaded. :)"
			    chmod -R 777 /home/cod4/gamefiles
			    chown -R $PUID:$PGID /home/cod4/gamefiles
			fi
		else
			echo "Mod enabled (Is not modernpaintball)"
		fi
		ls -1 /home/cod4/gamefiles/usermaps/ > /home/cod4/.callofduty4/usercustommaps.list
		./cod4x18_dedrun "+set dedicated $SERVERTYPE" "+set net_port $PORT" "+set fs_game Mods/$MODNAME" "$EXTRA" "+exec $EXECFILE" "$MAP"
	else
		echo "Not using Mod"
		ls -1 /home/cod4/gamefiles/usermaps/ > /home/cod4/.callofduty4/usercustommaps.list
		./cod4x18_dedrun "+set dedicated $SERVERTYPE" "+set net_port $PORT" "$EXTRA" "+exec $EXECFILE" "$MAP"
	fi
fi
