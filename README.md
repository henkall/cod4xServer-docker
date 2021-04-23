# COD4 Docker dedicated server #
Runs a Call of duty 4 Modern Warfare dedicated server in a Docker container.

Update: New feature. The docker can now get the gamefiles for you.
<img align="right" src="https://raw.githubusercontent.com/henkall/docker-cod4/master/cod4.ico">

[![](https://images.microbadger.com/badges/version/henkallsn/docker-cod4.svg)](https://microbadger.com/images/henkallsn/docker-cod4 "Image Version")
[![](https://images.microbadger.com/badges/image/henkallsn/docker-cod4.svg)](https://microbadger.com/images/henkallsn/docker-cod4 "Image Size")
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/henkallsn)
- Based on:
    - [Cod4x](https://cod4x.me/) server program
    - Unzip and curl to download the Cod4x
- You should go get the Windows client from https://cod4x.me/
    - It is a patch to Call of Duty 4 Modern Warfare so you are able to se the server.
- Works with custom mods and usermaps
- You can find a sample file to a "server.cfg" file on github.
~~~
https://github.com/henkall/docker-cod4
~~~

## Here is a example to get going with a server using compose. ##
~~~
---
version: "2"
services:
  cod4server:
    image: henkallsn/docker-cod4
    # Change the name if you want to.
    container_name: COD4DED
    network_mode: "host"
    environment:
      - READY=YES
      - EXECFILE=server.cfg
      - SERVERTYPE=1
      # This port can be changed. It is UDP.
      - PORT=28960
      - MAP=+map_rotate
      # Mod name can be empty
      - MODNAME=
      - EXTRA=+set sv_authorizemode -1
      - GETGAMEFILES=1
    volumes:
      # Remember to change this
      - /Path/to/COD4/gamefiles:/home/cod4/gamefiles
      - /Path/to/htmlfolder/serverstats:/home/cod4/.callofduty4
~~~

Note the files can be found in the installed game directory. 
~~~
\Activision\Call of Duty 4 - Modern Warfare
~~~

Note the following.

The server.cfg file should be located in the main folder. 

If you are running with a mod then the server.cfg file for that mod has to be in the same folder as the mod.

| **Host path** | **Container path** | Note |
| --- | --- | --- |
| /Path/to/COD4/gamefiles | /home/cod4/gamefiles | This is where the main, zone, mods and usermaps folders is going to be|
| /Path/to/htmlfolder/serverstats | /home/cod4/.callofduty4 | This is where the statusfiles is being generated (serverstatus.xml and usercustommaps.list). Some of these files is used for the webgui to function. Most likely it will be in /Path/to/AppData/wwwphp/html/serverstats but may bee difrent from case to case.|

| **Folders** | **Description** |
| --- | --- |
| main | I copied the contents of this from my CoD4:MW |
| zone | I copied the contents of this from my CoD4:MW |
| Mods | I keep any mods I want to use on the server in here |
| usermaps | I keep my custom maps in here |

Important:

The docker uses "EXECFILE", "PORT", "MAP", "MODNAME" and "EXTRA" enviroment variable to pass commands to the servers startup.
It also uses the "READY" enviroment variable just to check if you want to do this. :) If Empty it won't start.
Here is a list of commands that I use:

| ** Variable name ** | **Description** | **Value** |
|---|---|---|
| READY | Checking if you are Ready. Server don't start if this is empty | YES |
| EXECFILE | The name of the config file that should be used. Placed in the "main" folder if you are not using mods. When mods is used you can place the file on the same folder as the mod. | server.cfg |
| SERVERTYPE | 2 Is for Internet. 1 Is for LAN. If 2 is used you have to use: set sv_authtoken "mytokenhere" in the server.cfg file. You can read about it [HERE]. |  1 |
| PORT | Set what port the server should run on. If left empty this defaults to 28960 | 28960 |
| MAP | Starts the server with the defined rotate sequens in server.cfg file. | +map_rotate |
| MODNAME | Defines what mod you whant to use. Write the name of the folder that you mod is in. For example moderpaintball. | $MODNAME$ |
| EXTRA | 1 only allows players with legal copies to join, 0 allows cracked players, and -1 allows both types of players while the Activison authentication server is down. | +set sv_authorizemode -1 |
| GETGAMEFILES | Tells the server to get gamefiles or not. 1 is to get files. 0 is not to get files. | 1 |


[HERE]: https://cod4x.me/index.php?/forums/topic/2814-new-requirement-for-cod4-x-servers-to-get-listed-on-masterserver/
## Testing

1. Run a COD4 client and try to connect to `yourhostIPaddress:28960`

OBS: If you can't see the server in the game then try to add the server ip to the favorites in Call of Duty server list. Remember the portnumber. Also check your filter so you allow it to show moded servers.

If you are running version 1.7 of the game then get the patch from https://cod4x.me/ (The Windows client download). This can be removed again if you don't want to use it anymore.
