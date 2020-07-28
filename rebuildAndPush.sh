#!/usr/bin/env bash

set -eu

command cd "$( command cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for i in $(ls -d go*)
do
	docker build -t playwithgo/$i -f $i/Dockerfile .
	docker push playwithgo/$i
done

