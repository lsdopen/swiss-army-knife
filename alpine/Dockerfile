FROM alpine

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
RUN apk fix && \
    apk --no-cache --update add \ 
    bash \
    less \
    wget \
    ca-certificates \
    curl \
    vim \
    git \
    tar \
    unzip \
    nmap-ncat \
    tcptraceroute \
    traceroute \
    bind-tools \
    p7zip \
    rsync \
    httpie \
    jq \
    iputils-ping \
    iputils \
 && rm -rf /var/cache \
 && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/bin/kubectl \
 && rm ./kubectl


## Webify. Thanks Cron.weekly
## https://github.com/beefsack/webify/
# This assumes below that you already built webify
# and just copies the binary into the image
COPY ./webify /usr/local/bin/webify

EXPOSE 8080
ENTRYPOINT ["sleep", "infinity"]

