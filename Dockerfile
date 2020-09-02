FROM ubuntu:20.04

# Need the Timezone set else apt-get will prompt for user interaction
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Install anything you need
RUN apt-get update
RUN apt-get install -y \
    openssh-server \
    bash \
    curl

# Fix SSH permissions that always haunt me
RUN mkdir -p /var/run/sshd /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN chmod 0700 /root/.ssh
RUN chmod 0600 /root/.ssh/authorized_keys

# Add the keys your keys here. I wanted to keep everything in the Dockerfile because I am simple
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxZL18D5uG4isdf3Nc6l0J/OJ6UE9lkXK7RAqd54muG neil@lsd.co.za" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINYLlgyqIqCbvIYy/7wrALSa+OrCyOqYDhBy+bXuzYq rainer@lsd.co.za" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/gbFPMzTifHUABqSfXPeLS81ch/dJj/dgfmFvDaOpb clive@lsd.co.za" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqcU6ptqV2+qEaq/pTHiYf+opG3eX+Wx5pJ36/xMCUS neil.maderthaner@lsd.co.za" >> /root/.ssh/authorized_keys

# Only allow SSH via key
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin without-password/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
