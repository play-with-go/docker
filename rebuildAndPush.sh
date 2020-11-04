#!/usr/bin/env bash

set -euo pipefail
shopt -s inherit_errexit

push=true

while getopts ":b" opt; do
  case $opt in
    b)
      push=false
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

command cd "$( command cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for i in $(find * -mindepth 1 -name Dockerfile -print)
do
	i=$(dirname $i)
	docker build -t playwithgo/$i -f $i/Dockerfile .
	if [ "$push" == "true" ]
	then
		docker push playwithgo/$i
	fi
done

