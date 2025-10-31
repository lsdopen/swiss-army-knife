FROM alpine:latest

#ENTRYPOINT /usr/bin/bash -c "/usr/bin/sleep infinity"

# Install software
RUN apk fix && \
    apk --no-cache --update add \
        bash \
        bind-tools \
        btop \
        ca-certificates \
        curl \
        diffutils \
        elinks \
        fio \
        gawk \
        git \
    gzip \
        hdparm \
        httpie \
        inetutils-telnet \
        iperf \
        iputils \
        iputils-ping \
        jq \
        less \
    mailutils \
        mtr \
    musl \
    musl-utils \
    musl-locales \
        nano \
        nmap \
        nmap-ncat \
        openldap-clients \
        openssh-client-default \
        openssl \
        p7zip \
        rsync \
        strace \
        sudo \
        tar \
        tcpdump \
        tcptraceroute \
        tmux \
        traceroute \
    tzdata \
        unzip \
        vim \
        wget \
        zip

# Set Timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
## Webify. Thanks Cron.weekly
#ADD https://github.com/beefsack/webify/releases/download/v1.5.0/webify-v1.5.0-linux-amd64.tar.gz .
#RUN tar -C /usr/bin/ -xzf webify-v1.5.0-linux-amd64.tar.gz webify \
#    && rm webify-v1.5.0-linux-amd64.tar.gz

EXPOSE 8080
# for webify
