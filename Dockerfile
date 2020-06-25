FROM ubuntu
# Running options to COD4 server
ENV READY=""
ENV PORT="28960"
ENV MODNAME=""
ENV MAP="+map_rotate"
ENV EXTRA=""
ENV SERVERTYPE=""
ENV EXECFILE=""
# Installing dependencies
RUN apt-get update && \
    apt-get install -y gcc-multilib g++-multilib unzip curl
# Adding user: cod4
RUN groupadd -r cod4 && useradd --no-log-init -r -g cod4 cod4
# Adding files from github
ADD cod4 /home/cod4/
# Setting permissions
RUN chown -R cod4:cod4 /home/cod4

USER cod4
WORKDIR /home/cod4

# Making file executable
RUN chmod +x script.sh

ENTRYPOINT ["/home/cod4/script.sh"]
VOLUME ["/home/cod4/gamefiles/"]
