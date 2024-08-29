# mkdocker

MkDocker is a docker image which will build and service a mkdocs site.
It can pull the site from a git repository, or use a mounted directory.

# Usage

## Git

```
docker run -d --env "MKDOCKER_REPOSITORY_URL=github.com/g2forge/mkdocker" --env "MKDOCKER_REPOSITORY_BRANCH=main" --env "MKDOCKER_REPOSITORY_DIRECTORY=example" --publish 127.0.0.1:8080:80 ghcr.io/g2forge/mkdocker:main
```

## Local

```
docker run -d --mount type=bind,source=${pwd},target=/mkdocker/docs --publish 127.0.0.1:8080:80 ghcr.io/g2forge/mkdocker:main
```

## Environment Variables

* `MKDOCKER_REPOSITORY_URL` - The git repository to clone, without the protocol (default: `github.com/g2forge/mkdocker`)
* `MKDOCKER_REPOSITORY_LOGIN` - A login (`username:password` or `github_PAT`) for the repository (default: none)
* `MKDOCKER_REPOSITORY_BRANCH` - The branch in the git repository to build (default: `main`)
* `MKDOCKER_REPOSITORY_DIRECTORY` - The subdirectory in the git repository to run the build in (default: `example`)
* `MKDOCKER_LOCAL_DIRECTORY` - The directory inside the docker container to clone the repository in to, or to just use if already mounted (default: `/mkdocker/docs`)
* `MKDOCKER_VENV_DIRECTORY` - The directory inside the docker container to use for the python virtual environment (default: `/mkdocker/venv`). This is only necessary if a `requirements.txt` is present, and can optionally be mounted to a docker volume for persistence.
* `MKDOCKER_SERVE` - A boolean flag to enable `mkdocs serve` if set to `1` (default: `0`)

## Requirements

While the standard mkdocs and mkdocs-material packages are already installed, you can require other python packages by creating a `requirements.txt` in the repository directory.
If this file exists, a virtual environment will be created, and any packages will be installed in it.

## Scripts

mkdocker can run scripts both before and after the mkdocs build.
Simply create `scripts/pre` and `scripts/post` files in the `MKDOCKER_REPOSITORY_DIRECTORY` directory, and mark them executable.
One example of this is shown in this repository to created [protected pages](example/scripts/post) by modifying the nginx config.

## Control File

Each script takes two arguments: the path to a temp directory for use by the scripts, and the path to the control file.
The `pre` script should create this file, and both mkdocker and the `post` script will consume it.
If the `pre` script does not exist or does not create the file, mkdocker will.

Each line of the control file represents a separate mkdocs build, though only the last build will be served when `MKDOCKER_SERVE` is set all will be built.
Each line specifies a repository-relative or absolute path for the source, and a HTTP root relative path for the destination separated by a space (using bash quoting).
`mkdocs` will be run once per line.

The default control file is:

```
. .
```

# Development

* Build -   `docker build ./ -t mkdocker:latest`
* Bash -    `docker run --rm -it --entrypoint bash mkdocker:latest`
* Example - `docker run --mount type=bind,source=${pwd},target=/mkdocker/docs --publish 127.0.0.1:8080:80 mkdocker:latest`
