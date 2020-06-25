FROM ubuntu

# Running options to COD4 server 
ENV READY=""
ENV PORT="28960"
ENV MODNAME=""
ENV MAP="+map_rotate"
ENV EXTRA=""
ENV SERVERTYPE=""
ENV EXECFILE=""

RUN apt-get update && \
    apt-get install -y libstdc++6 build-essential gcc-multilib g++-multilib unzip curl nano

RUN groupadd -r cod4 && useradd --no-log-init -r -g cod4 cod4
ADD cod4 /home/cod4/
RUN chown -R cod4:cod4 /home/cod4

USER cod4
WORKDIR /home/cod4

RUN chmod +x script.sh
ENTRYPOINT ["/bin/bash"]

VOLUME ["/home/cod4/gamefiles/"]
