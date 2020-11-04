# golang:1.15.3
FROM golang@sha256:1ba0da74b20aad52b091877b0e0ece503c563f39e37aa6b0e46777c4d820a2ae

# Latest git
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-groovy.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
  apt-get update && \
  apt-get -y install git=1:2.29.2-0ppa1~ubuntu20.04.1

RUN apt-get -y install sudo

# Clean up
RUN apt-get -y autoremove && \
  apt-get clean

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

RUN groupadd -r -g 1000 gopher && \
  useradd -s /bin/bash -u 1000 -m --no-log-init -r -g gopher gopher && \
  usermod -aG sudo gopher && \
  echo "gopher ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY bashrc /home/gopher/.bashrc
COPY gitconfig /home/gopher/.gitconfig

RUN chown gopher:gopher /home/gopher/.bashrc /home/gopher/.gitconfig && \
  chmod 600 /home/gopher/.bashrc /home/gopher/.gitconfig

USER 1000

# Do not set GOPATH
ENV GOPATH=

# By default, run bash endlessly. This can be overriden by providing an
# alternative command at runtime
CMD while true ; do /bin/bash; done
