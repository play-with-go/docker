FROM golang@sha256:46b35fa37b05cbf653680cc472ee81c06f5291357fea0af475419c2f48e06b6f

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
RUN chmod 755 /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bash"]
