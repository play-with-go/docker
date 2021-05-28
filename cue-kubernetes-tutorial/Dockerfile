# syntax = docker/dockerfile:experimental@sha256:de85b2f3a3e8a2f7fe48e8e84a65f6fdd5cd5183afa6412fff9caa6871649c44

# golang:1.16
FROM golang@sha256:f3f90f4d30866c1bdae90012b506bd5e557ce27ccd2510ed30a011c44c1affc8

# docker
RUN apt-get update
RUN apt-get -y install     apt-transport-https     ca-certificates     curl     gnupg-agent     software-properties-common apt-utils
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io

# docker-compose
RUN curl -sL "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Latest git
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-groovy.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
  apt-get update && \
  apt-get -y install git=1:2.31.1-0ppa1~ubuntu20.04.1

RUN apt-get -y install sudo vim nano

# kubectl
RUN apt-get install -y apt-transport-https ca-certificates curl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl
RUN apt-mark hold kubectl

# cue
RUN GOBIN=/usr/local/go/bin go install cuelang.org/go/cmd/cue@v0.4.0

# k3d
RUN curl -s https://raw.githubusercontent.com/rancher/k3d/v4.4.4/install.sh | TAG=v4.4.4 bash

# Clean up
RUN apt-get -y autoremove && \
  apt-get clean

# TODO: Remove extraneous stuff
# RUN apt-get -y --allow-remove-essential remove curl wget apt

COPY ./cue-kubernetes-tutorial/entrypoint.sh /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

RUN groupadd -r -g 1000 gopher && \
  useradd -s /bin/bash -u 1000 -m --no-log-init -r -g gopher gopher && \
  usermod -a -G docker gopher && \
  usermod -aG sudo gopher && \
  echo "gopher ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Image environment
ENV PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GOPATH=
ENV GOMAXPROCS=1

RUN mkdir /home/gopher/.ssh

COPY profile /home/gopher/.profile
COPY bashrc /home/gopher/.bashrc
COPY gitconfig /home/gopher/.gitconfig
COPY sshconfig /home/gopher/.ssh/config

RUN chown gopher:gopher /home/gopher/.bashrc /home/gopher/.gitconfig /home/gopher/.profile /home/gopher/.ssh /home/gopher/.ssh/config && \
  chmod 600 /home/gopher/.bashrc /home/gopher/.gitconfig /home/gopher/.profile /home/gopher/.ssh/config && \
  chmod 700 /home/gopher/.ssh

USER 1000

# By default, run bash endlessly. This can be overriden by providing an
# alternative command at runtime
CMD while true ; do /bin/bash -l; done
