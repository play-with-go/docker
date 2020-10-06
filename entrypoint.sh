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

# Otherwise, we are root and expected to ultimately exec as gopher.
# Do some environment setup then exec as gopher
if [ "${GITEA_USERNAME:-}" != "" ] && [ "${GITEA_PASSWORD:-}" != "" ]
then
	cat <<EOD >> /home/gopher/.netrc
machine gopher.live
login $GITEA_USERNAME
password $GITEA_PASSWORD

EOD
	chmod 600 /home/gopher/.netrc
fi
cd /home/gopher
export HOME=/home/gopher
exec "$@"
