# CRIMAC-LSSS-cloud
docker image for running LSSS in the cloud

# Build container image
docker build -t lsss-vnc .

# Run container with noVNC web on port 8080
docker run -d -p 8080:6901 --name lsss-vnc lsss-vnc

Open http://localhost:8080/vnc.html?password=vncpassword to access the desktop and click on the **LSSS shortcut** on the desktop to start LSSS