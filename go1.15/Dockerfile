FROM sha256:75605a4155391abe376fc8124083ec52a2409ceb8a6b5ac6aae7eca133353ce3

# Latest git
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu groovy main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-groovy.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
  apt-get update && \
  apt-get update && \
  apt-get -y install git=1:2.28.0-0ppa1~ubuntu20.10.1

# Clean up
RUN apt-get -y autoremove && \
  apt-get clean

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# By default, run bash endlessly. This can be overriden by providing an
# alternative command at runtime
CMD while true ; do /bin/bash; done
