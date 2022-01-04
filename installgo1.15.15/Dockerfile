# buildpack-deps:buster-scm, base of golang:1.15.15
FROM buildpack-deps@sha256:07e999f2b4c56d4a9e8e5be86f2e2d865c22e6786e0322f7316bef4a3f65765f

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
