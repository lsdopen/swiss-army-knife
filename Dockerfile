FROM ubuntu:22.04

# Need the Timezone set else apt-get will prompt for user interaction
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Install anything you need
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    bash \
    wget \
    ca-certificates \
    curl \
    vim-tiny \
    ncat \
    tcptraceroute \
    traceroute \
    dnsutils \
    p7zip-full \
    rsync \
    httpie \
    jq \
    p7zip-rar \
    iputils-ping \
    && apt-get install -y --no-install-recommends git \
    && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists /var/lib/dpkg/info \
    && rm -rf /usr/share/doc /usr/share/man \
    && ln -s /usr/bin/vim-tiny /usr/bin/vim \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/bin/kubectl \
    && rm ./kubectl

## Webify. Thanks Cron.weekly
ADD https://github.com/beefsack/webify/releases/download/v1.5.0/webify-v1.5.0-linux-amd64.tar.gz .
RUN tar -C /usr/bin/ -xzf webify-v1.5.0-linux-amd64.tar.gz webify \
    && rm webify-v1.5.0-linux-amd64.tar.gz

EXPOSE 8080
ENTRYPOINT ["sleep", "infinity"]
