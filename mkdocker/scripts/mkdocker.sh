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
echo "----------"
echo "Current directory: $(pwd)"
echo "Directory listing:"
ls -alR ./
echo "----------"

echo "Running build"
if [ -x scripts/pre ]; then
	echo Running pre script
	./scripts/pre
fi
mkdocs build -d /usr/share/nginx/html
if [ -x scripts/post ]; then
	echo Running post script
	./scripts/post
fi

nginx -g "daemon off;"
