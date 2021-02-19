# syntax = docker/dockerfile@sha256:e2a8561e419ab1ba6b2fe6cbdf49fd92b95912df1cf7d313c3e2230a333fdbcc
# SHA256 above is an absolute reference to docker/dockerfile:1.2.1

# The comment regarding the syntax reference is not at the top of the file
# because the syntax line must be the first in the file.

# buildpack-deps:buster-scm, base of golang:1.15.8
FROM buildpack-deps@sha256:67ad07dd937bd85df686b5a02dc3bf27746645d397505b317e06ee56ac29b87d

RUN apt-get update && apt-get -y install sudo vim nano

# Clean up
RUN apt-get -y autoremove && \
  apt-get clean

# Remove extraneous stuff
RUN apt-get -y --allow-remove-essential remove curl apt

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

RUN groupadd -r -g 1000 gopher && \
  useradd -s /bin/bash -u 1000 -m --no-log-init -r -g gopher gopher && \
  usermod -aG sudo gopher && \
  echo "gopher ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Image environment
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GOPATH=
ENV GOMAXPROCS=1

COPY profile_empty /home/gopher/.profile
COPY bashrc /home/gopher/.bashrc
COPY gitconfig /home/gopher/.gitconfig

RUN chown gopher:gopher /home/gopher/.bashrc /home/gopher/.gitconfig /home/gopher/.profile && \
  chmod 600 /home/gopher/.bashrc /home/gopher/.gitconfig /home/gopher/.profile

USER 1000

# By default, run bash endlessly. This can be overriden by providing an
# alternative command at runtime
CMD while true ; do /bin/bash -l; done
