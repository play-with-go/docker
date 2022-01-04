#!/usr/bin/env bash

set -euo pipefail
shopt -s inherit_errexit

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

pushOrLoad="--push"
platform="linux/amd64,linux/arm64"
optb=false
optl=false

while getopts ":bl" opt; do
  case $opt in
    b)
		optb=true
      pushOrLoad=""
      ;;
    l)
		optl=true
      pushOrLoad="--load"
		platform="$(go env GOOS)/$(go env GOARCH)"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
shift $(($OPTIND - 1))

if $optb && $optl
then
	echo "cannot specify -b and -l"
	exit 1
fi

command cd "$( command cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

files=$(find * -mindepth 1 -name Dockerfile -print)
if [ "$#" != 0 ]
then
	files="$@"
fi

for i in $files
do
	i=$(dirname $i)
	cmd="docker buildx build $pushOrLoad -t playwithgo/$i --platform $platform -f $i/Dockerfile ."
	echo "Running: $cmd"
	$cmd
done

