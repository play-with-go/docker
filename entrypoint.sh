#!/bin/sh

set -eu

if [ "$#" -eq 0 ]
then
  exit
fi

# Pick up any mounted CA certs, e.g. mkcert. But don't be noisy about it
if [ "${GOPHERLIVE_ROOTCA:-}" != "" ]
then
	echo "$GOPHERLIVE_ROOTCA" > /usr/local/share/ca-certificates/playwithgo_rootca.crt
	update-ca-certificates > /dev/null 2>&1
fi

if [ "${PLAYWITHGO_NOGOPHER:-}" != "true" ]
then
	cat <<'EOD' >> /home/gopher/.bashrc
export PS1='$ '
EOD
	cat <<'EOD' >> /home/gopher/.gitconfig
[user]
		  email = gopher@gopher.com
		  name = Random Gopher
[init]
		  defaultBranch = main
EOD
	if [ "${GITEA_USERNAME:-}" != "" ] && [ "${GITEA_PASSWORD:-}" != "" ]
	then
		cat <<EOD >> /home/gopher/.netrc
machine gopher.live
login $GITEA_USERNAME
password $GITEA_PASSWORD

EOD
		chown gopher:gopher /home/gopher/.netrc
		chmod 600 /home/gopher/.netrc
	fi
	cd /home/gopher
	export HOME=/home/gopher
        exec "$@"
else
	exec "$@"
fi
