#!/bin/bash
set -eu -o pipefaile

cd /mkdocker/docs
if [ -d .git ]; then
	git pull
else
	git clone "https://${MKDOCKER_REPOSITORY_URL}" .
fi

cd "${MKDOCKER_REPOSITORY_DIRECTORY}"
mkdocs build -d /usr/share/nginx/html
nginx -g "daemon off;"
