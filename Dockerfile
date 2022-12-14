FROM ubuntu:20.04

# Need the Timezone set else apt-get will prompt for user interaction
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Install anything you need
RUN apt-get update
RUN apt-get install -y \
    openssh-server \
    bash \
    wget \
    curl \
    openjdk-11-jre \
    git \
    vim \
    python2 \
    netcat \
    telnet \
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
    
# Fix SSH permissions that always haunt me
RUN mkdir -p /var/run/sshd /root/.ssh && touch /root/.ssh/authorized_keys && chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/authorized_keys

# Add your keys here. I wanted to keep everything in the Dockerfile because I am simple
# This should probably be turned into a single command 
# cat << EOF > /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxZL18D5uG4isdf3Nc6l0J/OJ6UE9lkXK7RAqd54muG" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINYLlgyqIqCbvIYy/7wrALSa+OrCyOqYDhBy+bXuzYq" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gbFPMzTifHUABqSfXPeLS81ch/dJj/dgfmFvDaOpb" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqcU6ptqV2+qEaq/pTHiYf+opG3eX+Wx5pJ36/xMCUS" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUlau5tbkL3h9IP1hIeW1NFIxYvl+8uqsDhnNL5WYnu"  >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBH4v3QAgNMbQQpdfs1U9IJ3INFVY7e1+x3kBKuiUOVe stef" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUlau5tbkL3h9IP1hIeW1NFIxYvl+8uqsDhnNL5WYnu" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHCAIpiGIUPB0CrTL7GOxTXJX5UhhYxktydz3p7A5HH" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5yiR7jKErsHcsgG8ogWCNOaF/TLz+QIDU+49VSFXly" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILbyeNbZvaRJNQAB1XLbe9k5hGPPirhF3uV6J4MClaIu" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMyOknfkoeU/ax+N850OUlf015wEIs5Uj/KAjQb3U3x" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpTjCulY345Ef6s9ZfIylDVKa8Qfw3LJFX+O5K7S6DR" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBj1FwT0Rwr2LEj6Rox1rshRDoFkCptsAMbvn+VY7MT" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbzDt6BN5T3gvJA0ilx/O/F69PReqdciKm/pIFnDTlt" >> /root/.ssh/authorized_keys

# Only allow SSH via key
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin without-password/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
EXPOSE 8080
# for webify
CMD ["/usr/sbin/sshd", "-D"]
