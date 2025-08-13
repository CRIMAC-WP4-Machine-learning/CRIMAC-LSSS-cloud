#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
set -u

echo "Install LSSS"
LSSS_DOWNLOAD_URL="https://marec.no/tmp/lsss-3.1.0-rc1-20250721-1247-linux.zip"
LSSS_VERSION="3.1.0-rc1"
LSSS_BUILD_DATE="20250721-1247"

APPS_ROOT=/opt
LSSS_INSTALL_DIR=/$APPS_ROOT/lsss-install

mkdir -p $LSSS_INSTALL_DIR
wget -O $LSSS_INSTALL_DIR/lsss.zip $LSSS_DOWNLOAD_URL
unzip $LSSS_INSTALL_DIR/lsss.zip -d $LSSS_INSTALL_DIR
rm $LSSS_INSTALL_DIR/lsss.zip
unzip $LSSS_INSTALL_DIR/lsss-$LSSS_VERSION-$LSSS_BUILD_DATE/lsss-$LSSS_VERSION-linux.zip -d $LSSS_INSTALL_DIR
mv $LSSS_INSTALL_DIR/lsss-$LSSS_VERSION $APPS_ROOT
rm -rf $LSSS_INSTALL_DIR

## Add desktop shortcut for LSSS.sh
#RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=LSSS\nExec=/opt/lsss-$LSSS_VERSION/lsss/LSSS.sh\nIcon=/headless/lsss-$LSSS_VERSION/lsss/LSSS.png\nTerminal=true" > /headless/Desktop/LSSS.desktop
