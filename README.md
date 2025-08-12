# CRIMAC-LSSS-cloud
docker image for running LSSS in the cloud

# Build Container image
docker build -t lsss-vnc .

# Run Container with noVNC web on port 8080
docker run -d -p 8080:6901 --name lsss-vnc lsss-vnc

# Open http://<ip>:8080/vnc.html?password=vncpassword