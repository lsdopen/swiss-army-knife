FROM ubuntu:20.04

# Need the Timezone set else apt-get will prompt for user interaction
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Install anything you need
RUN apt-get update && apt-get install -y \
    openssh-server \
    bash \
    wget \
    curl \
    git \
    vim \
    ncat \
    telnet \
    dnsutils \
    p7zip-full \
    rsync \
    httpie \
    jq \
    p7zip-rar \
    iputils-ping && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists \
    && rm -rf /usr/share/man /usr/share/doc

# Fix SSH permissions that always haunt me
# Only allow SSH via key, and change port to 2200
# SSH login fix with PAM. Otherwise user is kicked off after login
RUN mkdir -p /var/run/sshd /root/.ssh && touch /root/.ssh/authorized_keys && chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/authorized_keys \
    && sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin without-password/g' /etc/ssh/sshd_config \
    && echo 'Port 2200' >> /etc/ssh/sshd_config \
    && echo 'AddressFamily inet' >> /etc/ssh/sshd_config \
    && echo '#ListenAddress 0.0.0.0' >> /etc/ssh/sshd_config \
    && sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd \
    && cat << EOF > /root/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBH4v3QAgNMbQQpdfs1U9IJ3INFVY7e1+x3kBKuiUOVe stef
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbzDt6BN5T3gvJA0ilx/O/F69PReqdciKm/pIFnDTlt jg
sh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxZL18D5uG4isdf3Nc6l0J/OJ6UE9lkXK7RAqd54muG nw
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUlau5tbkL3h9IP1hIeW1NFIxYvl+8uqsDhnNL5WYnu mac
EOF
# Add your keys above. I wanted to keep everything in the Dockerfile because I am simple

## Webify. Thanks Cron.weekly
ADD https://github.com/beefsack/webify/releases/download/v1.5.0/webify-v1.5.0-linux-amd64.tar.gz .
RUN tar -C /usr/bin/ -xzf webify-v1.5.0-linux-amd64.tar.gz webify \
    && rm webify-v1.5.0-linux-amd64.tar.gz

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# change SSH to be a non-priv port
EXPOSE 2200
EXPOSE 8080
# for webify
CMD ["/usr/sbin/sshd", "-D"]
