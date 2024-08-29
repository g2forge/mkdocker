#!/bin/bash
set -eu -o pipefail

SCRIPT_TEMP="${MKDOCKER_TEMP_DIRECTORY}/script-temp"
mkdir -pv "${SCRIPT_TEMP}"

if [ ! -d "${MKDOCKER_LOCAL_DIRECTORY}" ]; then
	mkdir -pv "${MKDOCKER_LOCAL_DIRECTORY}"
	cd "${MKDOCKER_LOCAL_DIRECTORY}"
	
	if [ -d .git ]; then
		git pull
	else
		if [ $MKDOCKER_REPOSITORY_LOGIN ]; then
			echo "Login specified"
			git clone "https://${MKDOCKER_REPOSITORY_LOGIN}@${MKDOCKER_REPOSITORY_URL}" .
		else
			echo "Login not specified"
			git clone "https://${MKDOCKER_REPOSITORY_URL}" .
		fi;
		git checkout "${MKDOCKER_REPOSITORY_BRANCH}"
	fi
else
	cd "${MKDOCKER_LOCAL_DIRECTORY}"
fi

cd "${MKDOCKER_REPOSITORY_DIRECTORY}"
echo "----------"
echo "Current directory: $(pwd)"
echo "----------"

if [ -f requirements.txt ]; then
	if [ ! -d "${MKDOCKER_VENV_DIRECTORY}" ] || [ -z "$(ls -A "${MKDOCKER_VENV_DIRECTORY}")" ]; then
		echo "Creating virtual environment"
		python3 -m venv "${MKDOCKER_VENV_DIRECTORY}"
	fi
	echo "Activating virtual environment"
	. "${MKDOCKER_VENV_DIRECTORY}/bin/activate"
	echo "Installing python requirements"
	pip install -r requirements.txt
fi

echo "Running build"
if [ -x scripts/pre ]; then
	echo Running pre script
	./scripts/pre "${SCRIPT_TEMP}" "${MKDOCKER_TEMP_DIRECTORY}/control"
fi

if [ ! -f "${MKDOCKER_TEMP_DIRECTORY}/control" ]; then
	cat << EOF > "${MKDOCKER_TEMP_DIRECTORY}/control"
. .
EOF
fi
# For all but the last site, build them
while read -r SOURCE TARGET; do
	echo "Building ${SOURCE} to ${TARGET}"
	pushd "${SOURCE}"
	mkdocs build -d "/usr/share/nginx/html/${TARGET}"
	popd
done < <(head -n -1 "${MKDOCKER_TEMP_DIRECTORY}/control")

# For the last site, build or serve it
read -r SOURCE TARGET < <(tail -n 1 "${MKDOCKER_TEMP_DIRECTORY}/control")
if [ "${MKDOCKER_SERVE}" = 0 ]; then
	echo "Building ${SOURCE} to ${TARGET}"
	pushd "${SOURCE}"
	mkdocs build -d "/usr/share/nginx/html/${TARGET}"
	popd
	if [ -x scripts/post ]; then
		echo Running post script
		./scripts/post "${SCRIPT_TEMP}" "${MKDOCKER_TEMP_DIRECTORY}/control"
	fi
	
	if [ -d "${MKDOCKER_VENV_DIRECTORY}" ]; then
		echo "Deactivating virtual environment"
		deactivate
	fi
	
	nginx -g "daemon off;"
else
	echo "Serving ${SOURCE}"
	pushd "${SOURCE}"
	mkdocs serve -a "0.0.0.0:80"
	popd
fi
