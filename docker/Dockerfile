FROM ubuntu:22.04

# Define environment variables
ENV LSSS_VERSION="3.1.0-rc2"
ENV LSSS_BUILD_DATE="20250812-1430"
ENV LSSS_DOWNLOAD_URL="https://marec.no/tmp/lsss-$LSSS_VERSION-$LSSS_BUILD_DATE-linux.zip"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install required packages and tools
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server novnc websockify openbox tint2 xterm \
    unzip wget \
    zsh vim nano \
    && rm -rf /var/lib/apt/lists/*

# Set root password to 'rootpassword' (change as needed)
# Commented out to avoid security issues in production
# RUN echo 'root:rootpassword' | chpasswd

# Copy desktop configuration files
COPY openbox /etc/xdg/openbox
COPY tint2 /etc/xdg/tint2

# Redirect / to vnc.html in noVNC
COPY novnc/index.html /usr/share/novnc/index.html

# Install LSSS
ARG LSSS_INSTALL_ROOT=/opt
ARG LSSS_INSTALL_DIR=$LSSS_INSTALL_ROOT/lsss-install
RUN mkdir -p $LSSS_INSTALL_DIR \
    && wget -O $LSSS_INSTALL_DIR/lsss.zip $LSSS_DOWNLOAD_URL \
    && unzip $LSSS_INSTALL_DIR/lsss.zip -d $LSSS_INSTALL_DIR \
    && rm $LSSS_INSTALL_DIR/lsss.zip \
    && unzip $LSSS_INSTALL_DIR/lsss-$LSSS_VERSION-$LSSS_BUILD_DATE/lsss-$LSSS_VERSION-linux.zip -d $LSSS_INSTALL_DIR \
    && mv $LSSS_INSTALL_DIR/lsss-$LSSS_VERSION $LSSS_INSTALL_ROOT \
    && rm -rf $LSSS_INSTALL_DIR

# Expose ports (6080 for noVNC, 5900 for VNC)
EXPOSE 6080 5900

# Start TigerVNC server with Openbox, noVNC, and LSSS (auto-restart LSSS)
ENV SCREEN_RESOLUTION=1366x768
ENV DISPLAY=:0

# Copy entrypoint script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Create non-root user 'lsss' with home directory and zsh shell
ARG USER_NAME=lsss
ARG USER_UID=1000  
ARG USER_GID=1000 
ARG USER_SHELL=/bin/zsh
ARG USER_HOME=/lsss
RUN groupadd --gid $USER_GID $USER_NAME \
    && useradd --create-home --home-dir $USER_HOME \
       --shell $USER_SHELL --uid $USER_UID --gid $USER_GID $USER_NAME
USER $USER_NAME
WORKDIR $USER_HOME

# Use script as CMD
CMD ["/usr/local/bin/start.sh"]