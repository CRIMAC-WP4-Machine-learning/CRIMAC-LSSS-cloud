# Example Dockerfile
FROM ubuntu:latest

# Install Java, desktop environment, VNC server, and web server
RUN apt-get update && apt-get install -y openjdk-17-jre xfce4 tigervnc-standalone-server novnc websockify unzip

# Set arguments for provenance
ARG version_number
ARG commit_sha
ARG LSSS_VERSION_VER=lsss-3.1.0
ARG LSSS_VERSION_REL=rc1
ARG LSSS_VERSION_T=20250721-1247
ARG LSSS_VERSION=${LSSS_VERSION_VER}-${LSSS_VERSION_REL}-${LSSS_VERSION_T}-linux

# Set labels for provenance
LABEL COMMIT_SHA=$commit_sha
LABEL VERSION_NUMBER=$version_number
LABEL LSSS_VERSION=$LSSS_VERSION

# Set environment variables for provenance
ENV VERSION_NUMBER=$version_number
ENV COMMIT_SHA=$commit_sha
ENV LSSS_VERSION=$LSSS_VERSION

# Download Korona
RUN wget https://marec.no/tmp/${LSSS_VERSION}.zip

# Unpack Korona
RUN unzip /${LSSS_VERSION}.zip
RUN rm /${LSSS_VERSION}.zip
RUN unzip /${LSSS_VERSION_VER}-${LSSS_VERSION_REL}-${LSSS_VERSION_T}/${LSSS_VERSION_VER}-${LSSS_VERSION_REL}-linux.zip -d /
RUN rm /${LSSS_VERSION_VER}-${LSSS_VERSION_REL}-${LSSS_VERSION_T}/${LSSS_VERSION_VER}-${LSSS_VERSION_REL}-linux.zip

# Create the .vnc directory
RUN mkdir -p /root/.vnc

# Configure VNC server and start script
RUN echo "startxfce4 &" > /root/.vnc/xstartup && chmod +x /root/.vnc/xstartup
# VNC port
EXPOSE 5901
# noVNC web port
EXPOSE 6080

# Command to start VNC server and websockify for noVNC
CMD ["sh", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && websockify --web /usr/share/novnc/ 6080 localhost:5901"]