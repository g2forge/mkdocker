#!/bin/bash
set -eu -o pipefail

cd /mkdocker/docs
if [ -d .git ]; then
	git pull
else
	git clone "https://${MKDOCKER_REPOSITORY_URL}" .
	git checkout "${MKDOCKER_REPOSITORY_BRANCH}"
fi

cd "${MKDOCKER_REPOSITORY_DIRECTORY}"
mkdocs build -d /usr/share/nginx/html
nginx -g "daemon off;"
