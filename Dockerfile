FROM ubuntu
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
VOLUME ["/home/cod4/gamefiles/"]
# Installing dependencies
RUN apt-get update && \
    apt-get install -y gcc-multilib g++-multilib unzip curl xz-utils
WORKDIR /home/cod4/gamefiles
# Adding files from github
COPY --chown=1000 cod4/script.sh /home/cod4/
# Adding user "cod4" and setting permissions
RUN adduser --system cod4 --home /home/cod4 --uid 1000 && \
    chsh -s /bin/bash cod4 && \
    chown -R cod4 /home/cod4 && \
    chmod -R 777 /home/cod4 && \
    chown -R cod4 /home/cod4/gamefiles && \
    chmod -R 777 /home/cod4/gamefiles && \
    # Making file executable
    chmod +x /home/cod4/script.sh
ENTRYPOINT ["/bin/bash","/home/cod4/script.sh"]
