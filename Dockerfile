# https://github.com/ConSol/docker-headless-vnc-container/blob/master/Dockerfile.debian-xfce-vnc
FROM consol/debian-xfce-vnc 
ENV REFRESHED_AT=2022-10-12

# Switch to root user to install additional software
USER 0

## Install packages
RUN apt update && apt install -y wget unzip nano
RUN apt install -y rclone rsync

## switch back to default user
USER 1000

# Download and extract LSSS
RUN wget https://marec.no/tmp/lsss-3.1.0-rc1-20250721-1247-linux.zip && \
    unzip lsss-3.1.0-rc1-20250721-1247-linux.zip -d ./lsss-install && \
    unzip ./lsss-install/lsss-3.1.0-rc1-20250721-1247/lsss-3.1.0-rc1-linux.zip -d ./ && \
    rm lsss-3.1.0-rc1-20250721-1247-linux.zip && \
    rm -rf lsss-install

## Add desktop shortcut for LSSS.sh
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=LSSS\nExec=/headless/lsss-3.1.0-rc1/lsss/LSSS.sh\nIcon=/headless/lsss-3.1.0-rc1/lsss/LSSS.png\nTerminal=false" > /headless/Desktop/LSSS.desktop
