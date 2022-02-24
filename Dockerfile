FROM lsiobase/guacgui:amd64-latest

MAINTAINER C.J. May <lawndoc@protonmail.com>

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Build arguments
ARG VERSION="11.0.6"
ARG LOCALE="en-US"

# Tor browser info
ENV APPNAME="Tor Browser"
ENV VERSION=$VERSION
ENV LOCALE=$LOCALE

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Default resolution, change if you like
ENV WIDTH=1920
ENV HEIGHT=1080

ENV HOME /tmp

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################

# Update and install packages needed for setup
RUN export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y
RUN apt-get update && \
    apt-get install -y gnupg apt-transport-https lsb-release wget

# Add tor project's deb repository
RUN echo "deb     [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main" > /etc/apt/sources.list.d/tor.list
RUN echo "deb-src [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main" >> /etc/apt/sources.list.d/tor.list
RUN wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg

# Install tor browser
RUN apt-get update && \
    apt-get install -y tor torbrowser-launcher deb.torproject.org-keyring


## Download Tor browser and verify signature
#RUN wget https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_${LOCALE}.tar.xz.asc && \
#    wget https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_${LOCALE}.tar.xz
#RUN gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org && \
#    gpg --output /tmp/tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290 && \
#    gpgv --keyring /tmp/tor.keyring tor-browser-linux64-${VERSION}_${LOCALE}.tar.xz.asc tor-browser-linux64-${VERSION}_${LOCALE}.tar.xz
#
## Extract Tor browser and make it exacutable
#RUN mkdir /tor-browser && \
#    tar -xvf tor-browser-linux64-${VERSION}_${LOCALE}.tar.xz -C /tor-browser/ --strip-components 1
#RUN sed 's^usr/bin/env .^tor-browser^' /tor-browser/start-tor-browser.desktop > /tmp/desktopfile && \
#    sed s^"\"\$(dirname \"\$\*\")\""^/tor-browser^g /tmp/desktopfile > /tmp/desktopfile2 && \
#    sed 's^ExecShell=.^ExecShell=/tor-browser^' /tmp/desktopfile2 > /tor-browser/start-tor-browser.desktop
#RUN cd /tor-browser && \
#    chmod +x start-tor-browser.desktop && \
#    chmod +x Browser/execdesktop && \
#    chmod +x Browser/start-tor-browser

#########################################
##           GUI APP SETUP             ##
#########################################

# Set security
WORKDIR /tmp
RUN mkdir -p /etc/my_init.d && \
    echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy X app start script to right location
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh
COPY root /


#########################################
##         EXPORTS AND VOLUMES         ##
#########################################
VOLUME ["/config"]
EXPOSE 3389 8080

