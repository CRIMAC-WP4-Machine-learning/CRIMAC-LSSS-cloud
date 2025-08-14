#!/bin/bash
set -e

# Start TigerVNC server
vncserver :0 -geometry "${SCREEN_RESOLUTION}" -SecurityTypes None -xstartup /usr/bin/openbox-session &
VNC_PID=$!

# Start noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &
WEBSOCKIFY_PID=$!

# Trap termination signals and clean up
cleanup() {
    echo "Stopping services..."
    kill $VNC_PID $WEBSOCKIFY_PID || true
    exit 0
}
trap cleanup SIGINT SIGTERM

# Run LSSS in a loop
while true; do
    /opt/lsss-${LSSS_VERSION}/lsss/LSSS.sh
    sleep 2
done
