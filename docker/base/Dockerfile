FROM ubuntu:20.04
LABEL Author="Shubham Rasal" Email="devops.shubham.rasal@gmail.com"

#prevent dpkg errors
ENV TERM=xterm-256color

#set mirrrs to IN
RUN sed -i "s/http:\/\/archive./http:\/\/in.archive./g" /etc/apt/sources.list

#Install python runtime
RUN apt-get update && \
    apt-get install -y \
    -o APT::Install-Recommend=false -o APT::Install-Suggest=false \
    python3 python3-virtualenv  

# Create Virutal environment
# Upgrade PIP in vitual environment to latest version
RUN virtualenv /appenv && \
    . /appenv/bin/activate  && \
    pip install pip --upgrade

# Add entrypoint script
ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]

