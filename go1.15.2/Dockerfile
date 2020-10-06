# golang:1.15.2
FROM golang@sha256:da7ff43658854148b401f24075c0aa390e3b52187ab67cab0043f2b15e754a68

# Latest git
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu groovy main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-groovy.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
  apt-get update && \
  apt-get update && \
  apt-get -y install git=1:2.28.0-0ppa1~ubuntu20.10.1

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

# By default, run bash endlessly. This can be overriden by providing an
# alternative command at runtime
CMD while true ; do /bin/bash; done
