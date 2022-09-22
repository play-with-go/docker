# golang:1.19.1
FROM golang@sha256:2d17ffd12a2cdb25d4a633ad25f8dc29608ed84f31b3b983427d825280427095

RUN apt-get update && apt-get -y install sudo vim nano

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

ENV PATH=/home/gopher/go/bin:$PATH
RUN go install cuelang.org/go/cmd/cue@v0.4.4-0.20220923112746-fe50dff0dce8

# By default, run bash endlessly. This can be overriden by providing an
# alternative command at runtime
CMD while true ; do /bin/bash -l; done
