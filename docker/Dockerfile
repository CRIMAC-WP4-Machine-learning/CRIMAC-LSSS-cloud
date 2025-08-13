FROM ubuntu:22.04

# Define environment variables
ENV SCREEN_RESOLUTION=1366x768
ENV LSSS_VERSION="3.1.0-rc2"
ENV LSSS_BUILD_DATE="20250812-1430"
ENV LSSS_DOWNLOAD_URL="https://marec.no/tmp/lsss-$LSSS_VERSION-$LSSS_BUILD_DATE-linux.zip"
ENV DISPLAY=:0
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install LSSS
ENV APPS_ROOT=/opt
ENV LSSS_INSTALL_DIR=/$APPS_ROOT/lsss-install
RUN apt-get update && apt-get install -y wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $LSSS_INSTALL_DIR \
    && wget -O $LSSS_INSTALL_DIR/lsss.zip $LSSS_DOWNLOAD_URL \
    && unzip $LSSS_INSTALL_DIR/lsss.zip -d $LSSS_INSTALL_DIR \
    && rm $LSSS_INSTALL_DIR/lsss.zip \
    && unzip $LSSS_INSTALL_DIR/lsss-$LSSS_VERSION-$LSSS_BUILD_DATE/lsss-$LSSS_VERSION-linux.zip -d $LSSS_INSTALL_DIR \
    && mv $LSSS_INSTALL_DIR/lsss-$LSSS_VERSION $APPS_ROOT \
    && rm -rf $LSSS_INSTALL_DIR

RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    novnc \
    websockify \
    openbox \
    xterm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY openbox/menu.xml /etc/xdg/openbox/menu.xml
COPY openbox/rc.xml /etc/xdg/openbox/rc.xml

# Redirect / to vnc.html in noVNC
COPY index.html /usr/share/novnc/index.html

# Create user 'lsss' with home /lsss
RUN useradd -m -d /lsss lsss
USER lsss
ENV HOME=/lsss
WORKDIR /lsss

# Expose ports (6080 for noVNC, 5900 for VNC)
EXPOSE 6080 5900

# Start TigerVNC server with Openbox, noVNC, and LSSS (auto-restart LSSS)
CMD ["/bin/bash", "-c", "\
vncserver :0 -geometry $SCREEN_RESOLUTION -SecurityTypes None -xstartup /usr/bin/openbox-session & \
websockify --web=/usr/share/novnc/ 6080 localhost:5900 & \
while true; do /opt/lsss-$LSSS_VERSION/lsss/LSSS.sh; sleep 2; done"]