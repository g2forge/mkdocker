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
* `MKDOCKER_REPOSITORY_BRANCH` - The branch in the git repository to build (default: `main`)
* `MKDOCKER_REPOSITORY_DIRECTORY` - The subdirectory in the git repository to run the build in (default: `example`)
* `MKDOCKER_LOCAL_DIRECTORY` - The directory inside the docker container to clone the repository in to, or to just use if already mounted (default `/mkdocker/docs`)

## Scripts

mkdocker can run scripts both before and after the mkdocs build.
Simply create `scripts/pre` and `scripts/post` files in the `MKDOCKER_REPOSITORY_DIRECTORY` directory, and mark them executable.
One example of this is shown in this repository to created [protected pages](example/scripts/post) by modifying the nginx config.

# Development

* Build -   `docker build ./ -t mkdocker:latest`
* Bash -    `docker run --rm -it --entrypoint bash mkdocker:latest`
* Example - `docker run --mount type=bind,source=${pwd},target=/mkdocker/docs --publish 127.0.0.1:8080:80 mkdocker:latest`
