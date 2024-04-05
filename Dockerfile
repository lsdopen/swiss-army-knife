FROM ubuntu:22.04

# Need the Timezone set else apt-get will prompt for user interaction
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Install anything you need
RUN apt-get update
RUN apt-get install -y \
    bash \
    wget \
    curl \
    openjdk-11-jre \
    git \
    vim \
    python2 \
    netcat \
    telnet \
    traceroute \
    dnsutils \
    p7zip-full \
    rsync \
    httpie \
    jq \
    p7zip-rar \
    iputils-ping && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists

## Webify. Thanks Cron.weekly
ADD https://github.com/beefsack/webify/releases/download/v1.5.0/webify-v1.5.0-linux-amd64.tar.gz .
RUN tar -C /usr/bin/ -xzf webify-v1.5.0-linux-amd64.tar.gz webify \
    && rm webify-v1.5.0-linux-amd64.tar.gz

EXPOSE 8080
# for webify
