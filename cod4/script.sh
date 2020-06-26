#!/usr/bin/env bash
if [ -d "main" ]
then
    echo "Directory main exists."
else
    echo "ERROR: Directory main is missing."
fi
if [ -d "zone" ]
then
    echo "Directory zone exists."
else
    echo "ERROR: Directory zone is missing"
fi
if [ -d "mods" ]
then
    echo "Directory mods exists."
else
    echo "ERROR: Directory mods is missing"
fi
if [ -d "usermaps" ]
then
    echo "Directory usermaps exists."
else
    echo "ERROR: Directory usermaps is missing"
fi
if [ -d "/home/cod4/gamefiles" ]
then
	echo "Directory gamefiles exists"
	folderperm=$(stat --format '%a' gamefiles)
	echo $folderperm
	if [ $folderperm -eq 2777 -o $folderperm -eq 777 ]
	then
		echo "Permissions fine"
		if [ ! -f cod4x18_dedrun ]
		then
			echo "cod4x18_dedrun not found... trying to download it."
			curl https://raw.githubusercontent.com/henkall/docker-cod4/master/cod4xfiles.zip -o cod4xfiles.zip && unzip -o cod4xfiles.zip && rm cod4xfiles.zip
			echo "Download Done"
			chmod +x cod4x18_dedrun
			echo ready
		else
			chmod +x cod4x18_dedrun
			echo "cod4x18_dedrun found" 
		fi
	else
		echo "Permissions on folder has to be 777 or 2777"
	fi
fi

echo "Setting server type"
if [[ -z "${SERVERTYPE}" ]]; then
  echo "The SERVERTYPE variable is empty."
  SERVERTYPE="1"
fi
echo "Setting port"
if [[ -z "${PORT}" ]]; then
  echo "The PORT variable is empty."
  PORT="28960"
fi
echo "Setting EXTRA arg"
if [[ -z "${EXTRA}" ]]; then
  echo "The EXTRA variable is empty."
  EXTRA="+set sv_authorizemode -1"
fi
echo "Setting exec file"
if [[ -z "${EXECFILE}" ]]; then
  echo "The EXECFILE variable is empty."
  EXECFILE="server.cfg"
fi
echo "Setting MAP"
if [[ -z "${MAP}" ]]; then
  echo "The MAP variable is empty."
  MAP="+map_rotate"
fi
echo "Checking if READY"
if [[ ! -z "${READY}" ]]; then
	echo "Config is Ready"
	if [[ ! -z "${MODNAME}" ]]; then
		echo "Mod enabled (using $MODNAME mod)"
		./cod4x18_dedrun "+set dedicated $SERVERTYPE" "+set net_port $PORT" "+set fs_game mods/$MODNAME" "$EXTRA" "+exec $EXECFILE" "$MAP"
	else
		echo "Not using Mod"
		./cod4x18_dedrun "+set dedicated $SERVERTYPE" "+set net_port $PORT" "$EXTRA" "+exec $EXECFILE" "$MAP"
	fi

fi
