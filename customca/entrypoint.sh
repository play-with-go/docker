#!/bin/sh

set -eu

if [ "${GOPHERLIVE_ROOTCA:-}" != "" ]
then
	echo "$GOPHERLIVE_ROOTCA" > /usr/local/share/ca-certificates/playwithgo_rootca.crt
	update-ca-certificates > /dev/null 2>&1
fi

exec "$@"
