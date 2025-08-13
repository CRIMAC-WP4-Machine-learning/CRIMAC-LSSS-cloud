# CRIMAC-LSSS-cloud

Docker image for running LSSS "Large Scale Survey System" (L-triple-S) in a web-based desktop (noVNC).

https://www.marec.no/products.htm

## Run with Docker

```sh
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
  -v "$(pwd)/lsss:/lsss" \
  -v "$(pwd)/path/to/datastore1:/lsss/datastore1" \
  -v "$(pwd)/path/to/datastore2:/lsss/datastore2" \
  --restart unless-stopped \
  $IMAGE:$TAG
```

## Run with Docker Compose
Edit [docker-compose.yml](docker/docker-compose.yml) as needed, then run:

```sh
docker compose up -d
```

### Example docker-compose.yml

```yaml
services:
  lsss-novnc:
    container_name: lsss-novnc
    image: ghcr.io/crimac-wp4-machine-learning/lsss-novnc:latest
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:6080" # HTTP Web user interface
      - "5900:5900" # Optional, VNC server port
    environment:
      - SCREEN_RESOLUTION=1366x768
    volumes:
      - ./lsss:/lsss # Main LSSS directory
      - ./path/to/datastore1:/lsss/datastore1 # Optional 1, replace with actual path
      - ./path/to/datastore2:/lsss/datastore2 # Optional 2, replace with actual path
    restart: unless-stopped
```

## Access the desktop
- Open [**http://localhost:8080/**](http://localhost:8080/) in your browser. You will be redirected to the noVNC client.
- Desktop resolution can be modified with the `SCREEN_RESOLUTION` environment variable
- To connect with a VNC client, use port 5900.

## Scaling the resolution to fit the browser window.

- Open the **noVNC pop-out** on the left side and click on the **gear icon**
- Check the **Clip to Window**
- Set the Scaling Mode to **Remote Resizing**

![Screenshot](novnc-screenshot.png)

## Notes
- The container will auto-start LSSS and provide an Openbox desktop environment.
- You can right-click the desktop for a limited Openbox menu (including a terminal emulator).
- Data directories can be mounted using the `volumes` section in Docker Compose.