#!/bin/sh

set -eu

if [ "$#" -eq 0 ]
then
  exit
fi

# If we are not root, or we have explicitly disabled doing anything to the
# gopher user account, simply exec
if [ "${PLAYWITHGO_NOGOPHER:-}" = "true" ]
then
	exec "$@"
fi

# Pick up any mounted CA certs, e.g. mkcert. But don't be noisy about it
if [ "${GOPHERLIVE_ROOTCA:-}" != "" ]
then
	echo "$GOPHERLIVE_ROOTCA" | sudo cp /dev/stdin /usr/local/share/ca-certificates/playwithgo_rootca.crt
	sudo update-ca-certificates > /dev/null 2>&1
fi

if [ "${GITEA_PRIV_KEY:-}" != "" ] && [ "${GITEA_PUB_KEY:-}" != "" ] && [ "${GITEA_KEYSCAN:-}" != "" ]
then
	echo "$GITEA_PRIV_KEY" > /home/gopher/.ssh/id_ed25519
	echo "$GITEA_PUB_KEY" > /home/gopher/.ssh/id_ed25519.pub
	echo "$GITEA_KEYSCAN" > /home/gopher/.ssh/known_hosts
	chmod 600 /home/gopher/.ssh/*

	git config --global url.ssh://git@gopher.live/.insteadOf https://gopher.live/
fi

# Specific to this guide, ensure that the GOCACHE and GOMODCACHE directories
# exist
if [ "${GOMODCACHE:-}" != "" ]
then
	sudo mkdir -p $GOMODCACHE
	sudo chown gopher:gopher $GOMODCACHE
fi
if [ "${GOCACHE:-}" != "" ]
then
	sudo mkdir -p $GOCACHE
	sudo chown gopher:gopher $GOCACHE
fi

# Start docker if we do not have a docker.sock file mounted
if [ ! -e /var/run/docker.sock ]
then
	# Create docker-group writable log file
	sudo touch /docker.log
	sudo chown root:docker /docker.log
	sudo chmod 664 /docker.log

	# # Start dockerd
	sudo dockerd > /docker.log 2>&1 &

	# Wait for docker to start by looking for /var/run/docker.sock
	# TODO: can we improve this?
	while true
	do
		if [ -e /var/run/docker.sock ]
		then
			break
		fi
		sleep 0.01
	done
fi

# Run our args
cd /home/gopher
export HOME=/home/gopher
exec "$@"
