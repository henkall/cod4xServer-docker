#!/bin/bash
echo "Server Starting ----------------------------------------------------------------------------------"


if [ -z "${PUID}" ]; then
  echo "Host user ID not found in environment. Using root (0)."
  export PUID=0
fi

if [ -z "${PGID}" ]; then
  echo "Host group ID not found in environment. Using root (0)."
  export PGID=0
fi

if ! getent group "${PGID}" | cut -d: -f1 | read; then 
  addgroup cod4 -g "${PGID}"
  HOST_GROUPNAME="cod4"
else
  HOST_GROUPNAME=`getent group "${PGID}" | cut -d: -f1`
fi

if ! getent passwd "${PUID}" | cut -d: -f1 | read; then 
  adduser cod4 -D -G "$HOST_GROUPNAME" --uid "$PUID"
  HOST_USERNAME="cod4"
else
  HOST_USERNAME=`getent passwd "${PUID}" | cut -d: -f1`
fi


if [ -d "main" ]
then
    echo " Directory main exists."
    foldermain=$(stat --format '%a' /root/gamefiles/main)
    if [ $foldermain -eq 2777 -o $foldermain -eq 777 ]
	then
	   echo "Permissions on 'main' directory fine"
    else
	   echo "ERROR: Permissions on 'main' directory has to be 777 or 2777"
	   chmod -R 2777 /root/gamefiles/main
	   echo "fix applied to main ---------------------------------------------------------------------------"
    fi
else
    echo "ERROR: Directory main is missing."
fi
if [ -d "zone" ]
then
    echo " Directory zone exists."
    folderzone=$(stat --format '%a' /root/gamefiles/zone)
    if [ $folderzone -eq 2777 -o $folderzone -eq 777 ]
	then
	   echo "Permissions on 'zone' directory fine"
    else
	   echo "ERROR: Permissions on 'zone' directory has to be 777 or 2777"
	   chmod -R 2777 /root/gamefiles/zone
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
    ls -1 /root/gamefiles/usermaps/ > /root/.callofduty4/usercustommaps.list
else
    echo "ERROR: Directory usermaps is missing"
    mkdir usermaps
    echo "usermaps directory has been created"
fi
if [ -d "/root/gamefiles" ]
then
	echo " Directory gamefiles exists"
	chmod -R 2777 /root/gamefiles
	chown -R $PUID:$PGID /root/gamefiles
	echo "Permissions fine"
	if [ ! -f cod4x18_dedrun ]
	then
		echo "cod4x18_dedrun not found... trying to download it."
		if [ $GETGAMEFILES -eq 1 ]
		then
			curl http://linuxgsm.download/CallOfDuty4/cod4x18_1790_lnxded.tar.xz -o cod4x18.tar.xz && tar -xf cod4x18.tar.xz && rm cod4x18.tar.xz
			curl https://raw.githubusercontent.com/henkall/cod4xServer-docker/master/cod4xfilesnew.zip -o cod4xfiles.zip && unzip -o cod4xfiles.zip && rm cod4xfiles.zip
			chmod -R 2777 runtime
			chown -R $PUID:$PGID runtime
		else
			curl https://raw.githubusercontent.com/henkall/cod4xServer-docker/master/cod4xfilesnew.zip -o cod4xfiles.zip && unzip -o cod4xfiles.zip && rm cod4xfiles.zip
			chmod -R 2777 runtime
			chown -R $PUID:$PGID runtime
		fi
		echo "Download Done"
		chmod +x cod4x18_dedrun
		echo ready
		chmod -R 2777 /root/gamefiles
		chown -R $PUID:$PGID /root/gamefiles
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
			    curl https://raw.githubusercontent.com/henkall/cod4xServer-docker/master/modernpainballv2.zip -o modernpaintball.zip && unzip -o modernpaintball.zip && rm modernpaintball.zip
			    curl https://www.notgoodbutcrazy.eu/NGBCteam/download/mods/modernpaintballv2.tar.bz2 -o mpmaps.tar.bz2
			    tar -xvjf mpmaps.tar.bz2 Paintball_mod/usermaps --strip-components=1
			    rm mpmaps.tar.bz2
			    echo "Mod downloaded. :)"
			    chmod -R 2777 /root/gamefiles
			    chown -R $PUID:$PGID /root/gamefiles
			fi
		else
			echo "Mod enabled (Is not modernpaintball)"
		fi
		ls -1 /root/gamefiles/usermaps/ > /root/.callofduty4/usercustommaps.list
		./cod4x18_dedrun "+set dedicated $SERVERTYPE" "+set net_port $PORT" "+set fs_game Mods/$MODNAME" "$EXTRA" "+exec $EXECFILE" "$MAP"
	else
		echo "Not using Mod"
		ls -1 /root/gamefiles/usermaps/ > /root/.callofduty4/usercustommaps.list
		./cod4x18_dedrun "+set dedicated $SERVERTYPE" "+set net_port $PORT" "$EXTRA" "+exec $EXECFILE" "$MAP"
	fi
fi
