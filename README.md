# CRIMAC-LSSS-cloud

Docker image for running LSSS "Large Scale Survey System" (L-triple-S) in a web-based desktop (noVNC).

https://www.marec.no/products.htm

## Run with Docker Compose
Edit [docker-compose.yml](docker/docker-compose.yml) as needed, then run:

```sh
docker compose up -d
```

## Access the desktop
- Open [**http://localhost:8080/**](http://localhost:8080/) in your browser.
- Or connect with a VNC client on port 5900.

## Notes
- The container will auto-start LSSS and provide an Openbox desktop environment.
- When LSSS application is terminated it will start up again.
- Terminal emulator is available by right clicking the desktop
- Data directories can be mounted using the `volumes` section in Docker Compose.
- noVNC default resolution can be modified with the `SCREEN_RESOLUTION` environment variable, only needed when using Local Scaling
- noVNC use Remote Resizing as default so it always fit into the browser window
- noVNC settings can be adjusted from the pop-out menu at the left side, under the gear icon.

![Screenshot](novnc-screenshot.png)

## Run with Docker

This script will first try to use the pre-built image at ghcr.io and if you do not have access it will build it locally.

```bash
#!/bin/bash

IMAGE="ghcr.io/crimac-wp4-machine-learning/lsss-novnc"
TAG="latest"

# Try to pull the image
if ! docker pull $IMAGE:$TAG; then
  echo "Remote image not available. Building locally..."
  docker build -t $IMAGE:$TAG .
fi

# Run the container
docker run -d \
  --name lsss-novnc \
  -p 8080:6080 \
  -p 5900:5900 \
  -e SCREEN_RESOLUTION=1366x768 \
  -v /etc/localtime:/etc/localtime:ro \
  -v "$(pwd)/LSSS_HOME:/lsss:rw" \
  -v "$(pwd)/LSSS_CONFIG:/lsss/.ApplicationData/lsss:rw" \
  -v "$(pwd)/LSSS_DATA:/lsss/LSSS_DATA:rw" \
  -v "$(pwd)/path/to/datastore1:/lsss/datastore1" \
  -v "$(pwd)/path/to/datastore2:/lsss/datastore2" \
  --restart unless-stopped \
  $IMAGE:$TAG
```