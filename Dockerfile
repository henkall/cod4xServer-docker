FROM romeoz/docker-apache-php
# Running options to COD4 server
ENV READY=""
ENV PORT="28960"
ENV MODNAME=""
ENV MAP="+map_rotate"
ENV EXTRA=""
ENV SERVERTYPE=""
ENV EXECFILE="server.cfg"
ENV PUID="1000"
ENV PGID="100"
ENV GETGAMEFILES="0"
# Setting a volume
VOLUME ["/root/gamefiles/"]
# Ports to webgui
EXPOSE 443 80
# Installing dependencies
RUN apt-get update && \
    apt-get install -y gcc-multilib g++-multilib unzip curl xz-utils nano && \
    rm -f /var/cache/apk/*
# Adding files from github
COPY cod4/script.sh /root
COPY cod4/entrypoint.sh /root
# Running with root
RUN chmod -R 2777 /root && \
    # Making file executable
    chmod +x /root/script.sh && \
    chmod +x /root/entrypoint.sh
WORKDIR /root/gamefiles
ENTRYPOINT ["/root/entrypoint.sh"]
