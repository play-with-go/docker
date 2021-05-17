# syntax = docker/dockerfile@sha256:e2a8561e419ab1ba6b2fe6cbdf49fd92b95912df1cf7d313c3e2230a333fdbcc
# SHA256 above is an absolute reference to docker/dockerfile:1.2.1

# The comment regarding the syntax reference is not at the top of the file
# because the syntax line must be the first in the file.

# golang:1.15.8
FROM golang@sha256:9fdb74150f8d8b07ee4b65a4f00ca007e5ede5481fa06e9fd33710890a624331

# Latest git
#
# TODO: use of the PPA like this is flakey. Move to a better solution.
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-groovy.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
  apt-get update && \
  apt-get -y install git=1:2.31.1-0ppa1~ubuntu20.04.1

RUN apt-get -y install sudo vim nano

# Clean up
RUN apt-get -y autoremove && \
  apt-get clean

# Remove extraneous stuff
RUN apt-get -y --allow-remove-essential remove curl wget apt

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

RUN groupadd -r -g 1000 gopher && \
  useradd -s /bin/bash -u 1000 -m --no-log-init -r -g gopher gopher && \
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
