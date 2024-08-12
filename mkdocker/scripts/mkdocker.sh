#!/bin/bash
set -eu -o pipefail

if [ ! -d "${MKDOCKER_LOCAL_DIRECTORY}" ]; then
	mkdir -pv "${MKDOCKER_LOCAL_DIRECTORY}"
	cd "${MKDOCKER_LOCAL_DIRECTORY}"
	
	if [ -d .git ]; then
		git pull
	else
		git clone "https://${MKDOCKER_REPOSITORY_URL}" .
		git checkout "${MKDOCKER_REPOSITORY_BRANCH}"
	fi
else
	cd "${MKDOCKER_LOCAL_DIRECTORY}"
fi

cd "${MKDOCKER_REPOSITORY_DIRECTORY}"
if [ -x scripts/pre ]; then ./scripts/pre; fi
mkdocs build -d /usr/share/nginx/html
if [ -x scripts/post ]; then ./scripts/post; fi
nginx -g "daemon off;"
