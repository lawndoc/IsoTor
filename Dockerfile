FROM lsiobase/guacgui:amd64-latest

MAINTAINER C.J. May <lawndoc@protonmail.com>

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100
ENV APPNAME="Tor Browser"

# Default resolution, change if you like
ENV WIDTH=1920
ENV HEIGHT=1080

ENV HOME /nobody

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################

# Install packages needed for app
RUN add-apt-repository ppa:micaflee/ppa
RUN export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y torbrowser-launcher

#########################################
##           GUI APP SETUP             ##
#########################################

# Set security
WORKDIR /nobody
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
