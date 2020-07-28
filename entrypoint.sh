#!/bin/sh

if [ "$#" -eq 0 ]
then
  exit
fi
USER_UID="${USER_UID:-1000}"
USER_GID="${USER_GID:-1000}"
groupadd -r -g $USER_GID gopher
useradd -s /bin/bash -u $USER_UID -m --no-log-init -r -g gopher gopher
cat <<'EOD' >> /home/gopher/.bashrc
export PS1='$ '
EOD
cat <<'EOD' >> /home/gopher/.gitconfig
[user]
        email = gopher@gopher.com
        name = Random Gopher
EOD
cd /home/gopher
export HOME=/home/gopher
exec setpriv --reuid gopher --regid gopher --init-groups "$@"
