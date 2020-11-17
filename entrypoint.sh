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

cd /home/gopher
export HOME=/home/gopher
exec "$@"
