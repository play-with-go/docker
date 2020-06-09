#!/usr/bin/env bash

set -eu

command cd "$( command cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for i in $(ls -d go*)
do
	command pushd $i > /dev/null
	docker build -t playwithgo/$i .
	docker push playwithgo/$i
	command popd > /dev/null
done

