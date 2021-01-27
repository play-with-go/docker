# syntax = docker/dockerfile@sha256:e2a8561e419ab1ba6b2fe6cbdf49fd92b95912df1cf7d313c3e2230a333fdbcc
# SHA256 above is an absolute reference to docker/dockerfile:1.2.1

# The comment regarding the syntax reference is not at the top of the file
# because the syntax line must be the first in the file.

# golang:1.15.2
FROM golang@sha256:da7ff43658854148b401f24075c0aa390e3b52187ab67cab0043f2b15e754a68 AS stage1

ENV GOCACHE=/root/.cache/go/gocache
ENV GOMODCACHE=/root/.cache/go/gomodcache
ENV CGO_ENABLED=0
ENV GOPATH=

ENV PATH /gobuild/bin:$PATH

RUN set -eux; \
  mkdir /gobuild; \
  cd /gobuild; \
  git init; \
  git remote add origin https://go.googlesource.com/go; \
  git fetch origin 7307e86afda3c5c7f6158d2469c39606fd1dba65; \
  git checkout FETCH_HEAD;

RUN --mount=type=cache,target=/root/.cache/go set -eux; \
  cd /gobuild/src; \
  ./make.bash; \
  go version; \
  go install std;

RUN set -eux; \
  rm -rf \
   /gobuild/pkg/*/cmd \
   /gobuild/pkg/bootstrap \
   /gobuild/pkg/obj \
   /gobuild/pkg/tool/*/api \
   /gobuild/pkg/tool/*/go_bootstrap \
   /gobuild/src/cmd/dist/dist \
   /gobuild/.git \
  ;

# buildpack-deps:buster-scm
FROM buildpack-deps@sha256:f010c9887ecea10d052247ef8befb79c2d17ea3f92ab6cb05039caab757fb14e

ENV PATH /usr/local/go/bin:$PATH

COPY --from=stage1 /gobuild /usr/local/go

# Latest git
#
# TODO: use of the PPA like this is flakey. Move to a better solution.
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-groovy.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
  apt-get update && \
  apt-get -y install git=1:2.30.0-0ppa1~ubuntu20.04.1

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
