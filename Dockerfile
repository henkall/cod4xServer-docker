FROM romeoz/docker-apache-php
# Running options to COD4 server
ENV READY=""
ENV PORT="28960"
ENV MODNAME=""
ENV MAP="+map_rotate"
ENV EXTRA=""
ENV SERVERTYPE=""
ENV EXECFILE=""
ENV PUID="1000"
ENV PGID="100"
ENV GETGAMEFILES="0"
# Setting a volume
VOLUME ["/root/gamefiles/"]
# Ports to webgui
EXPOSE 443 80
# Installing dependencies
RUN apt-get update && \
    apt-get install -y gcc-multilib g++-multilib unzip curl xz-utils nano
WORKDIR /root/gamefiles
# Adding files from github
COPY cod4/script.sh /root/
# Adding user "cod4" and setting permissions
RUN chsh -s /bin/bash root && \
    chmod -R 777 /root && \
    chmod -R 777 /root/gamefiles && \
    # Making file executable
    chmod +x /root/script.sh
#ENTRYPOINT ["/bin/bash","/root/script.sh"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
